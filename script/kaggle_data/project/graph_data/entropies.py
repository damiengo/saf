import pandas as pd
import matplotlib.pyplot as plt

class Entropies:

    def __init__(self, csv_path):
        self.df = pd.read_csv(csv_path)

    def mean_by_league(self):
        print "mean by league"
        providers = [('B365', 'sum_proba_b365'),
                     ('BW', 'sum_proba_bw'),
                     ('IW', 'sum_proba_iw'),
                     ('LB', 'sum_proba_lb'),
                     ('PS', 'sum_proba_ps'),
                     ('WH', 'sum_proba_wh'),
                     ('SJ', 'sum_proba_sj'),
                     ('VC', 'sum_proba_vc'),
                     ('GB', 'sum_proba_gb'),
                     ('BS', 'sum_proba_bs')]

        for lib, sum_col in providers:
            grouped_means = self.df.groupby(['league', 'season'])[sum_col].mean()
            datas = grouped_means.reset_index().pivot(index='season', columns='league', values=sum_col)

            #plot graph
            ax = datas.plot(figsize=(12,8), style=["-","--","-.",":","-","--","-.",":","-","--","-.",":"], marker='o', linewidth=2.0)
            fig = ax.get_figure()
            fig.patch.set_facecolor('white')

            #set title
            hfont = {'fontname':'Helvetica'}
            plt.title('PROBABILITY MEAN SUMS '+lib, fontsize=20, color='#444444', **hfont)

            ax.set_xlabel('')

            #set ticks roatation
            plt.xticks(rotation=50)

            plt.savefig('/home/dam/Images/sum_means/'+lib+'.png', facecolor='white')
            #plt.show()
