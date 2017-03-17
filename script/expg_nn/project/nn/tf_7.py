# -*- coding: utf-8 -*-
import sys
import numpy as np
import tensorflow as tf

class Network:

    # neural network with 1 layer of 2 softmax neurons
    def __init__(self, learning_rate=0.5, batch_size=200, iter=10):
        tf.set_random_seed(0)
        self.batch_size = batch_size
        self.iter=iter

        # input X: 3x1 distance, angle and head, the first dimension (None) will index the images in the mini-batch
        self.X = tf.placeholder(tf.float32, [None, 3], name='features')

        # correct answers
        self.Y_ = tf.placeholder(tf.float32, [None, 2], name='target')

        Xn = tf.nn.l2_normalize(self.X, dim=1)
        # reshape (test without)
        XX = tf.reshape(Xn, [-1, 3])

        nb_features = 3
        nb_target = 2

        ##################################
        # A multi-neuron logistic network.
        ##################################

        layer1_size = 3
        layer2_size = 3

        # Weights and Biases for layer 1
        W1 = tf.Variable(tf.truncated_normal([nb_features, layer1_size]), name='weights_layer1')
        B1 = tf.Variable(tf.zeros([layer1_size]), name='biases_layer1')

        # Weights and Biases for layer 2
        W2 = tf.Variable(tf.truncated_normal([layer1_size, layer2_size]), name='weights_layer2')
        B2 = tf.Variable(tf.zeros([layer2_size]), name='biases_layer2')

        # Weights and Biases out
        Wout = tf.Variable(tf.truncated_normal([layer2_size, nb_target]), name='weights_out')
        Bout = tf.Variable(tf.zeros([nb_target]), name='biases_out')

        # The model
        Y1     = tf.nn.relu(tf.matmul(XX, W1) + B1)
        Y2     = tf.nn.relu(tf.matmul(Y1, W2) + B2)
        self.Y = tf.nn.softmax(tf.matmul(Y2, Wout) + Bout)

        # cross-entropy
        # log takes the log of each element, * multiplies the tensors element by element
        # reduce_mean will add all the components in the tensor
        # so here we end up with the total cross-entropy for all images in the batch
        #self.cost = -tf.reduce_mean(self.Y_ * tf.log(self.Y)) * 10.0  # normalized for batches of 100 images,
        # *10 because  "mean" included an unwanted division by 10
        self.cost = tf.reduce_mean(-tf.reduce_sum(self.Y_*tf.log(self.Y), reduction_indices=1))

        # Multi-neuron end

        """

        ###################
        # A linear network.
        ###################

        self.W = tf.Variable(tf.truncated_normal([nb_features, nb_target]), name='weights')
        self.B = tf.Variable(tf.zeros([nb_target]), name='biases')
        self.Y = tf.matmul(XX, self.W) + self.B

        # Mean squared error
        self.cost = tf.reduce_sum(tf.pow(self.Y_-self.Y, 2))/(2*self.batch_size)
        #self.cost = tf.sqrt(tf.reduce_mean(tf.square(tf.subtract(self.Y_, self.Y))))

        # Linear end

        """

        # training
        self.train_step = tf.train.GradientDescentOptimizer(learning_rate).minimize(self.cost)

        # init
        init = tf.global_variables_initializer()
        self.sess = tf.Session()
        self.sess.run(init)

    """ Fits the network with features and targets """
    def fit(self, features, targets):
        # Add non goal
        targets_ng = np.column_stack(((1-targets), targets))
        nb_loops = len(features) % self.batch_size
        for j in xrange(self.iter):
            for i in xrange(0, nb_loops*self.batch_size, self.batch_size):
                batch_X = features[i:i+self.batch_size, :]
                batch_Y = targets_ng[i:i+self.batch_size, :]

                # the backpropagation training step
                t = self.sess.run([self.train_step], feed_dict={self.X: batch_X, self.Y_: batch_Y})
                #self.variable_summaries(self.cost)

        # Merge all the summaries and write them out to /tmp/mnist_logs (by default)
        #merged = tf.summary.merge_all()
        #train_writer = tf.summary.FileWriter('/tmp/train',
        #                                      self.sess.graph)

    """ Predicts from features """
    def predict(self, features):
        y = self.sess.run([self.Y], feed_dict={self.X: features})
        # y is an array containing 2 entries (no goal;goal)
        return y[0][:, 1]

    """
    Save the weights into files.
    """
    def save_weights(self, save_dir):
        saver = tf.train.Saver()
        saver.save(self.sess, save_dir+"/save.ckpt")

    """
    Load weights from files.
    """
    def load_weights(self, save_dir):
        saver = tf.train.Saver()
        saver.restore(self.sess, save_dir+"/save.ckpt")

    """Attach a lot of summaries to a Tensor (for TensorBoard visualization)."""
    def variable_summaries(self, var):
        with tf.name_scope('summaries'):
            mean = tf.reduce_mean(var)
            tf.summary.scalar('mean', mean)
            with tf.name_scope('stddev'):
                stddev = tf.sqrt(tf.reduce_mean(tf.square(var - mean)))
            tf.summary.scalar('stddev', stddev)
            tf.summary.scalar('max', tf.reduce_max(var))
            tf.summary.scalar('min', tf.reduce_min(var))
            tf.summary.histogram('histogram', var)
