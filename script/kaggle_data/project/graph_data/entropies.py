import pandas as pd
import matplotlib.pyplot as plt

class Entropies:

    def __init__(self, csv_path):
        self.df = pd.read_csv(csv_path)

    def mean_by_league(self):
        print "mean by league"
        providers = ['sum_proba_b365', 'sum_proba_bw', 'sum_proba_iw',
                     'sum_proba_lb', 'sum_proba_ps', 'sum_proba_wh',
                     'sum_proba_sj', 'sum_proba_vc', 'sum_proba_gb',
                     'sum_proba_bs']
        grouped_means = self.df.groupby(['league', 'season'])[providers].mean()

        datas = grouped_means['sum_proba_b365']
        datas = datas.reset_index().pivot(index='season', columns='league')

        #plot graph
        ax = datas.plot(figsize=(12,8), style=["-","--","-.",":"], marker='o')

        #set title
        plt.title('Probability mean sums', fontsize=16)

        #set ticks roatation
        plt.xticks(rotation=50)

        #keep colors for next graph
        #colors = [x.get_color() for x in ax.get_lines()]

        #remove x label
        #ax.set_xlabel('')

        plt.show()
