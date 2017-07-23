# -*- coding: utf-8 -*-
import logging as log
import tpot as tp

class ModelChooser:

    def __init__(self):
        log.basicConfig(level=log.DEBUG, format='%(asctime)s - %(levelname)-7s - %(message)s')

    def run(self, X_train, y_train, X_test, y_test, save_file):
        log.info("Run tPot")
        pipeline_optimizer = tp.TPOTClassifier(generations=5, population_size=20, cv=5,
                                            random_state=42, verbosity=2)
        pipeline_optimizer.fit(X_train, y_train)
        log.info(pipeline_optimizer.score(X_test, y_test))
        pipeline_optimizer.export(save_file)
