#!/usr/bin/env python3
#coding=utf8
from pygnuplot import gnuplot
import pandas as pd

#Transparent demo example comes from
#https://gnuplot.sourceforge.net/demo_6.0/finance.html

#Ceate a gnuplot context
g = gnuplot.Gnuplot(log = True)

#Set plotting style
g.set(output = "'finance.13.png'",
        term = 'pngcairo  transparent enhanced font "arial,8" fontscale 1.0 size 660, 320',
        label = ['1 "Acme Widgets" at graph 0.5, graph 0.9 center front',
            '2 "Courtesy of Bollinger Capital" at graph 0.01, 0.07',
            '3 "  www.BollingerBands.com" at graph 0.01, 0.03'],
        logscale = 'y',
        yrange = '[75:105]',
        ytics = '(105, 100, 95, 90, 85, 80)',
        xrange = '[50:253]',
        grid = '',
        lmargin = '9',
        rmargin = '2',
        format = 'x ""',
        xtics = '(66, 87, 109, 130, 151, 174, 193, 215, 235)',
        multiplot = True)

#3) Expressions and caculations
#A demostration to generate pandas data frame data in python.
df = pd.read_csv('examples/finance.dat',
        sep='\t',
        index_col = 0,
        parse_dates = True,
        #names = ['date', 'open','high','low','close', 'volume','volume_m50',
            'intensity','close_ma20','upper','lower '])
	names = ['Onboarding','AddService','AddServiceToNewAccount','AddSubscription','BlockVoucher','BookDeposit','AdjustMainAccount','CancelSubscription','ChangeSim','ChangeSubscription','CreateDocument','CreateIdentification','Gifting','HardBarring','LifeCycleSync','LifeCycleSyncTermination','LineBarring','LineUnBarring','MakePayment','MoveToFWA','NumberRecycle','ResumeService''StopAutoRenewal','SuspendService','TransferOfService','UpdateBucket','UpdateCreditLimit','UpdateLanguage','UpdateProfile','UnlockMpesa','UpdateService','DeviceBlacklistWhitelist','VoucherRecharge']

#4) Plotting: Since multiplot = True, we plot two subplot
g.plot_data(df,
        'using 0:2:3:4:5 notitle with candlesticks lt 8',
        'using 0:9 notitle with lines lt 3',
        'using 0:10 notitle with lines lt 1',
        'using 0:11 notitle with lines lt 2',
        'using 0:8 axes x1y2 notitle with lines lt 4',
        title = '"Change to candlesticks"',
        size = ' 1, 0.7',
        origin = '0, 0.3',
        bmargin = '0',
        ylabel = '"price" offset 1')
g.plot_data(df,
        'using 0:($6/10000) notitle with impulses lt 3',
        'using 0:($7/10000) notitle with lines lt 1',
        bmargin = '',
        format = ['x', 'y "%1.0f"'],
        size = '1.0, 0.3',
        origin = '0.0, 0.0',
        tmargin = '0',
        nologscale = 'y',
        autoscale = 'y',
        ytics = '500',
        xtics = '("6/03" 66, "7/03" 87, "8/03" 109, "9/03" 130, "10/03" 151, "11/03" 174, "12/03" 193, "1/04" 215, "2/04" 235)',
        ylabel = '"volume (0000)" offset 1')