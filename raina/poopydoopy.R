set.seed(1)

## Can we predict cholesterol levels based on dietary 
## cholesterol intake?

lm.fit <- lm(LBXTC ~ DR1TCHOL, train_data)
summary(lm.fit)
plot(lm.fit)


##Dietary cholesterol appears significant in predicting 
##cholesterol levels with a significance of 0.05
## Based on the plots, it doesn't look like the relationship is 
## linear.

fit <- lm(LBXTC ~ poly(DR1TCHOL, 10), data = train_data)
summary(fit)

## Using a polynomial model, the variables are only significant 
## using 4 degrees or less. 

fit <- lm(LBXTC ~ poly(DR1TCHOL, 4), data = train_data)
summary(fit)
plot(fit)

## Also, the plots indicate the relationship 
## may not be well-expressed by a polynomial either.

diet_var <- subset(train_data, select = -c(y, SEQN, SMAQUEX2, 
        LBDTCSI, WTDRD1, WTDR2D, DR1EXMER, DRDINT, DR1DBIH, 
        DR1LANG, DR1TNUMF, DR1DAY, DBQ095Z, DRQSPREP, DRQSDIET, 
        DR1_300, DR1TWS, SDDSRVYR, RIDEXMON, RIAGENDR, RIDAGEYR, 
        RIDRETH1, DMDCITZN, DMDHHSIZ, DMDFMSIZ, INDHHIN2, 
        INDFMIN2, INDFMPIR, DMDHRGND, DMDHRAGE, DMDHREDU, 
        DMDHRMAR, SIALANG, SIAPROXY, SIAINTRP, FIALANG, 
        MIALANG, FIAPROXY, MIAPROXY, FIAINTRP, MIAINTRP, 
        WTINT2YR, WTMEC2YR, SDMVPSU, DR1BWATZ, 1))

full <- lm(LBXTC ~ ., data = diet_var)
summary(full)








