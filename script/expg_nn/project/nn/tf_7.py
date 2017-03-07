# -*- coding: utf-8 -*-
import tensorflow as tf
from tensorflow.contrib.learn.python.learn.datasets.mnist import read_data_sets
tf.set_random_seed(0)

#TRTT 1:06:43

# neural network with 1 layer of 1 softmax neurons

# input X: 3x1 distance, angle and head, the first dimension (None) will index the images in the mini-batch
X = tf.placeholder(tf.float32, [None, 3], name='features')

# correct answers
Y_ = tf.placeholder(tf.float32, [None, 1], name='target')

# Weights
W = tf.Variable(tf.zeros([3, 1]), name='weights')

# biases
b = tf.Variable(tf.zeros([1]), name='biases')

# reshape (test without)
XX = tf.reshape(X, [-1, 3])

# The model
#Y = tf.nn.softmax(tf.matmul(XX, W) + b)
Y = tf.nn.sigmoid(tf.matmul(XX, W) + b)

# cross-entropy
# log takes the log of each element, * multiplies the tensors element by element
# reduce_mean will add all the components in the tensor
# so here we end up with the total cross-entropy for all images in the batch
cross_entropy = -tf.reduce_mean(Y_ * tf.log(Y)) * 1000.0  # normalized for batches of 100 images,
# *10 because  "mean" included an unwanted division by 10

# accuracy
accuracy = tf.reduce_sum(Y) / tf.reduce_sum(Y_)

expg_predicted = tf.reduce_sum(Y)

# training, learning rate = 0.005
train_step = tf.train.GradientDescentOptimizer(0.005).minimize(cross_entropy)

# init
init = tf.global_variables_initializer()
sess = tf.Session()
sess.run(init)


# You can call this function in a loop to train the model, 100 images at a time
def training_step(batch_X, batch_Y):
    # the backpropagation training step
    e, a, t = sess.run([expg_predicted, accuracy, train_step], feed_dict={X: batch_X, Y_: batch_Y})
    print "accuracy: "+str(a)+" - expg: "+str(e)+" - train: "+str(t)
