library(ARTool)
r.anal.data <- read.csv("~/Downloads/IGL/R Analysis Data/6e10Positivescsv.csv", header = TRUE)
r.anal.data$Dementia <- as.factor(r.anal.data$Dementia)
r.anal.data$Sex <- as.factor(r.anal.data$Sex)
str(r.anal.data)

# 1. Open one PDF file for everything
pdf("~/Downloads/IGL/R Analysis Data/all_analyses_output.pdf", width = 8, height = 11)

#6e10 Positive Area ART Anova Model
model.6e10 <- art(percent.6e10.positive.area ~ Sex*Dementia, data = r.anal.data)
anova(model.6e10)
plot.new()
anova_1 <- capture.output(anova(model.6e10))
text(0, 1, adj = c(0, 1), labels = paste(anova_1, collapse = "\n"), family = "mono", cex = 0.8)


#6e10 Interaction Plot
interaction.plot(x.factor = r.anal.data$Dementia, trace.factor = r.anal.data$Sex, response = r.anal.data$percent.6e10.positive.area,main="6e10_positivearea")

#-------------------------------------------------------------------------#

#GFAP Area ART Anova Model
model.gfap.pctarea <- art(GFAP_pctarea ~ Sex*Dementia, data= r.anal.data)
anova(model.gfap.pctarea)
plot.new()
anova_2 <- capture.output(anova(model.gfap.pctarea))
text(0, 1, adj = c(0, 1), labels = paste(anova_2, collapse = "\n"), family = "mono", cex = 0.8)


#GFAP Interaction Plot
interaction.plot(x.factor = r.anal.data$Dementia, trace.factor = r.anal.data$Sex, response = r.anal.data$GFAP_pctarea, main = "GFAP_pctarea")

#-------------------------------------------------------------------------#

#NEUN Red Pct Area ART Anova Model
model.NEUN.redpctarea <- art(NEUN_redpctarea ~ Sex*Dementia, data= r.anal.data)
anova(model.NEUN.redpctarea)

plot.new()
anova_3 <- capture.output(anova(model.NEUN.redpctarea))
text(0, 1, adj = c(0, 1), labels = paste(anova_3, collapse = "\n"), family = "mono", cex = 0.8)


#NEUN Red Pct Area Interaction Plot
interaction.plot(x.factor = r.anal.data$Dementia, trace.factor = r.anal.data$Sex, response = r.anal.data$NEUN_redpctarea, main = "NEUN_redpctarea")

#-------------------------------------------------------------------------#

#NEUN Total Pct Area ART Anova Model
model.NEUN.totalpctarea <- art(NEUN_totalpctarea ~ Sex*Dementia, data= r.anal.data)
anova(model.NEUN.totalpctarea)

plot.new()
anova_4 <- capture.output(anova(model.NEUN.totalpctarea))
text(0, 1, adj = c(0, 1), labels = paste(anova_4, collapse = "\n"), family = "mono", cex = 0.8)


#NEUN Total Pct Area Interaction Model
interaction.plot(x.factor = r.anal.data$Dementia, trace.factor = r.anal.data$Sex, response = r.anal.data$NEUN_totalpctarea, main = "NEUN_totalpctarea")

#-------------------------------------------------------------------------#

#I6 Pct Area ART Anova Model
model.I6.pctarea <- art(I6_pctarea ~ Sex*Dementia, data= r.anal.data)
anova(model.I6.pctarea)

plot.new()
anova_5 <- capture.output(anova(model.I6.pctarea))
text(0, 1, adj = c(0, 1), labels = paste(anova_5, collapse = "\n"), family = "mono", cex = 0.8)


#I6 Pct Area ART Interaction Plot
interaction.plot(x.factor = r.anal.data$Dementia, trace.factor = r.anal.data$Sex, response = r.anal.data$I6_pctarea, main = "I6_pctarea")

#-------------------------------------------------------------------------#

#Num Activated IBA1 Pos Cells Per Area SEAD ART Anova Model
model.num.activated.Iba1.pos.cellsperarea.SEAD <- art(num_activated_Iba1_positive_cells_per_area_SEA_AD ~ Sex*Dementia, data= r.anal.data)
anova(model.num.activated.Iba1.pos.cellsperarea.SEAD)

plot.new()
anova_6 <- capture.output(anova(model.num.activated.Iba1.pos.cellsperarea.SEAD))
text(0, 1, adj = c(0, 1), labels = paste(anova_6, collapse = "\n"), family = "mono", cex = 0.8)


#Num Activated IBA1 Pos Cells Per Area SEAD Interaction Plot
interaction.plot(x.factor = r.anal.data$Dementia, trace.factor = r.anal.data$Sex, response = r.anal.data$num_activated_Iba1_positive_cells_per_area_SEA_AD, main = "Num Activated Iba1 positive cells per area SEA_AD")


# Close and save the multi-page file
dev.off()
