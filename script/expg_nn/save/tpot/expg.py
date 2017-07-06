import numpy as np

from sklearn.model_selection import train_test_split
from xgboost import XGBClassifier

# NOTE: Make sure that the class is labeled 'class' in the data file
tpot_data = np.recfromcsv('PATH/TO/DATA/FILE', delimiter='COLUMN_SEPARATOR', dtype=np.float64)
features = np.delete(tpot_data.view(np.float64).reshape(tpot_data.size, -1), tpot_data.dtype.names.index('class'), axis=1)
training_features, testing_features, training_target, testing_target = \
    train_test_split(features, tpot_data['class'], random_state=42)

exported_pipeline = XGBClassifier(max_depth=3, n_estimators=100, nthread=1, subsample=0.45)

exported_pipeline.fit(training_features, training_target)
results = exported_pipeline.predict(testing_features)

"""

Imputing missing values in feature set
Generation 1 - Current best internal CV score: 0.908218587006
Generation 2 - Current best internal CV score: 0.908218587006
Generation 3 - Current best internal CV score: 0.90829515603
Generation 4 - Current best internal CV score: 0.90829515603
Generation 5 - Current best internal CV score: 0.908372196928

Best pipeline: XGBClassifier(input_matrix, XGBClassifier__learning_rate=DEFAULT, XGBClassifier__max_depth=3, XGBClassifier__min_child_weight=DEFAULT, XGBClassifier__n_estimators=100, XGBClassifier__nthread=1, XGBClassifier__subsample=0.45)
2017-07-06 22:35:07,267 - INFO    - 0.902096291177

"""
