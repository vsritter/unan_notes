





dat <- as.table(matrix(c(19,10,6,256), nrow = 2, byrow = TRUE)) colnames(dat) <- c("L1-pos","L1-neg")
rownames(dat) <- c("L2-pos","L2-neg")
epi.kappa(dat, method = "fleiss", alternative = "greater", conf.level = 0.95)
## The z test statistic is 11.53 (P < 0.01). We accept the alternative ## hypothesis that the kappa statistic is greater than zero.
## The proportion of agreements after chance has been excluded is ## 0.67 (95% CI 0.56 to 0.79). We conclude that, on the basis of
## this sample, that there is substantial agreement between the two ## laboratories.
## EXAMPLE 2 (from Watson and Petrie 2010, page 1170):
## Silva et al. (2007) compared an early pregnancy enzyme-linked immunosorbent ## assay test for pregnancy associated glycoprotein on blood samples collected ## from lactating dairy cows at day 27 after artificial insemination with
## transrectal ultrasound (US) diagnosis of pregnancy at the same stage.
## The results were as follows:
## ELISA positive, US positive: 596
## ELISA positive, US negative: 61
## ELISA negative, US positive: 29
## ELISA negative, Ul negative: 987
dat <- as.table(matrix(c(596,61,29,987), nrow = 2, byrow = TRUE)) colnames(dat) <- c("US-pos","US-neg")
rownames(dat) <- c("ELISA-pos","ELISA-neg")
epi.kappa(dat, method = "watson", alternative = "greater", conf.level = 0.95)
epi.ltd 61
## The proportion of agreements after chance has been excluded is
## 0.89 (95% CI 0.86 to 0.91). We conclude that that there is substantial ## agreement between the two pregnancy diagnostic methods.


library(epiR)


## EXAMPLE 1:
## A cross sectional study investigating the relationship between dry cat
## food (DCF) and feline urologic syndrome (FUS) was conducted (Willeberg
## 1977). Counts of individuals in each group were as follows:
## DCF-exposed cats (cases, non-cases) 13, 2163
## Non DCF-exposed cats (cases, non-cases) 5, 3349
## Outcome variable (FUS) as columns:
dat <- matrix(c(13,2163,5,3349), nrow = 2, byrow = TRUE)
rownames(dat) <- c("DF+", "DF-"); colnames(dat) <- c("FUS+", "FUS-"); dat

epi.2by2(dat = as.table(dat), method = "cross.sectional",
         conf.level = 0.95, units = 100, outcome = "as.columns")
## Outcome variable (FUS) as rows:
dat <- matrix(c(13,5,2163,3349), nrow = 2, byrow = TRUE)
rownames(dat) <- c("FUS+", "FUS-"); colnames(dat) <- c("DF+", "DF-"); dat
epi.2by2(dat = as.table(dat), method = "cross.sectional",
         conf.level = 0.95, units = 100, outcome = "as.rows")
## Prevalence ratio:
## The prevalence of FUS in DCF exposed cats is 4.01 (95% CI 1.43 to 11.23)
## times greater than the prevalence of FUS in non-DCF exposed cats.
## Attributable fraction in the exposed:
## In DCF exposed cats, 75% of FUS is attributable to DCF (95% CI 30% to
## 91%).
## Attributable fraction in the population:
## Fifty-four percent of FUS cases in the cat population are attributable
## to DCF (95% CI 4% to 78%).
## EXAMPLE 2:
## This example shows how the table function can be used to pass data to
## epi.2by2. Here we use the birthwgt data from the MASS package.
library(MASS)
dat1 <- birthwt; head(dat1)
## Generate a table of cell frequencies. First set the levels of the outcome
## and the exposure so the frequencies in the 2 by 2 table come out in the
## conventional format:
dat1$low <- factor(dat1$low, levels = c(1,0))
dat1$smoke <- factor(dat1$smoke, levels = c(1,0))
dat1$race <- factor(dat1$race, levels = c(1,2,3))
## Generate the 2 by 2 table. Exposure (rows) = smoke. Outcome (columns) = low.
tab1 <- table(dat1$smoke, dat1$low, dnn = c("Smoke", "Low BW"))
print(tab1)
## Compute the incidence risk ratio and other measures of association:
epi.2by2(dat = tab1, method = "cohort.count",
         conf.level = 0.95, units = 100, outcome = "as.columns")
## Odds ratio:
## The odds of having a low birth weight child for smokers is 2.02
## (95% CI 1.08 to 3.78) times greater than the odds of having a low birth
## weight child for non-smokers.
## Now stratify by race:
tab2 <- table(dat1$smoke, dat1$low, dat1$race,
              dnn = c("Smoke", "Low BW", "Race"))
print(tab2)

## Compute the crude odds ratio, the Mantel-Haenszel adjusted odds ratio
## and other measures of association:
rval <- epi.2by2(dat = tab2, method = "cohort.count",
                 conf.level = 0.95, units = 100, outcome = "as.columns")
print(rval)
## The Mantel-Haenszel test of homogeneity of the strata odds ratios is not
## significant (chi square test statistic 2.8; df 2; p-value = 0.247).
## We accept the null hypothesis and conclude that the odds ratios for
## each strata of race are the same.
## After accounting for the confounding effect of race, the odds of
## having a low birth weight child for smokers is 3.09 (95% CI 1.49 to 6.39)
## times that of non-smokers.
## Compare the Greenland-Robins confidence intervals for the Mantel-Haenszel
## adjusted attributable risk with the Wald confidence intervals for the
## Mantel-Haenszel adjusted attributable risk:
rval$massoc$ARisk.mh.green
rval$massoc$ARisk.mh.wald
## Now turn tab2 into a data frame where the frequencies of individuals in
## each exposure-outcome category are provided. Often your data will be
## presented in this summary format:
dat2 <- data.frame(tab2)
print(dat2)
## Re-format dat2 (a summary count data frame) into tabular format using the
## xtabs function:
tab3 <- xtabs(Freq ~ Smoke + Low.BW + Race, data = dat2)
print(tab3)
# tab3 can now be passed to epi.2by2:
rval <- epi.2by2(dat = tab3, method = "cohort.count",
                 conf.level = 0.95, units = 100, outcome = "as.columns")
print(rval)
## The Mantel-Haenszel adjusted odds ratio is 3.09 (95% CI 1.49 to 6.39). The
## ratio of the crude odds ratio to the Mantel-Haensel adjusted odds ratio is
## 0.66.
## What are the Cornfield confidence limits, the maximum likelihood
## confidence limits and the score confidence limits for the crude odds ratio?
rval$massoc$OR.crude.cfield
rval$massoc$OR.crude.mle
rval$massoc$OR.crude.score
## Cornfield: 2.02 (95% CI 1.07 to 3.79)
## Maximum likelihood: 2.01 (1.03 to 3.96)
# Score: 2.02 (95% CI 1.08 to 3.77)

## Plot the individual strata-level odds ratios and compare them with the
## Mantel-Haenszel adjusted odds ratio.
## Not run:
library(ggplot2); library(scales)
nstrata <- 1:dim(tab3)[3]
strata.lab <- paste("Strata ", nstrata, sep = "")
y.at <- c(nstrata, max(nstrata) + 1)
y.lab <- c("M-H", strata.lab)
x.at <- c(0.25, 0.5, 1, 2, 4, 8, 16, 32)
or.l <- c(rval$massoc$OR.mh$lower, rval$massoc$OR.strata.cfield$lower)
or.u <- c(rval$massoc$OR.mh$upper, rval$massoc$OR.strata.cfield$upper)
or.p <- c(rval$massoc$OR.mh$est, rval$massoc$OR.strata.cfield$est)
dat <- data.frame(y.at, y.lab, or.p, or.l, or.u)
ggplot(dat, aes(or.p, y.at)) +
  geom_point() +
  geom_errorbarh(aes(xmax = or.l, xmin = or.u, height = 0.2)) +
  labs(x = "Odds ratio", y = "Strata") +
  scale_x_continuous(trans = log2_trans(), breaks = x.at,
                     limits = c(0.25,32)) + scale_y_continuous(breaks = y.at, labels = y.lab) +
  geom_vline(xintercept = 1, lwd = 1) + coord_fixed(ratio = 0.75 / 1) +
  theme(axis.title.y = element_text(vjust = 0))
## End(Not run)
## EXAMPLE 3:
## A study was conducted by Feychting et al (1998) comparing cancer occurrence
## among the blind with occurrence among those who were not blind but had
## severe visual impairment. From these data we calculate a cancer rate of
## 136/22050 person-years among the blind compared with 1709/127650 person-
## years among those who were visually impaired but not blind.
## Not run:
dat <- as.table(matrix(c(136,22050,1709,127650), nrow = 2, byrow = TRUE))
rval <- epi.2by2(dat = dat, method = "cohort.time", conf.level = 0.95,
                 units = 1000, outcome = "as.columns")
summary(rval)$ARate.strata.wald
## The incidence rate of cancer was 7.22 cases per 1000 person-years less in the
## blind, compared with those who were not blind but had severe visual impairment
## (90% CI 6.00 to 8.43 cases per 1000 person-years).
round(summary(rval)$IRR.strata.wald, digits = 2)
## End(Not run)
## The incidence rate of cancer in the blind group was less than half that of the
## comparison group (incidence rate ratio 0.46, 90% CI 0.38 to 0.55).
## EXAMPLE 4:
epi.about 13
## A study has been conducted to assess the effect of a new treatment for
## mastitis in dairy cows. Eight herds took part in the study. The following
## data were obtained. The vectors ai, bi, ci and di list (for each herd) the
## number of cows in the E+D+, E+D-, E-D+ and E-D- groups, respectively.
## Not run:
hid <- 1:8
ai <- c(23,10,20,5,14,6,10,3)
bi <- c(10,2,1,2,2,2,3,0)
ci <- c(3,2,3,2,1,3,3,2)
di <- c(6,4,3,2,6,3,1,1)
dat <- data.frame(hid, ai, bi, ci, di)
print(dat)
## Re-format data frame dat into a format suitable for epi.2by2:
hid <- rep(1:8, times = 4)
exp <- factor(rep(c(1,1,0,0), each = 8), levels = c(1,0))
out <- factor(rep(c(1,0,1,0), each = 8), levels = c(1,0))
dat <- data.frame(hid, exp, out, n = c(ai,bi,ci,di))
dat <- xtabs(n ~ exp + out + hid, data = dat)
print(dat)
epi.2by2(dat = dat, method = "cohort.count", outcome= "as.columns")
## The Mantel-Haenszel test of homogeneity of the strata odds ratios is not
## significant (chi square test statistic 5.276; df 7; p-value = 0.626).
## We accept the null hypothesis and conclude that the odds ratios for each
## strata of herd are the same.
## After adjusting for the effect of herd, compared to untreated cows, treatment
## increased the odds of recovery by a factor of 5.97 (95% CI 2.72 to 13.13).
## End(Not run)







