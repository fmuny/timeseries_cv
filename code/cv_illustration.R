###
# Generate illustrations of CV approaches using ggplot
###

# Load packages
library(ggplot2)
library(dplyr)

# 1.) hv-Block Cross-Validation (Racine 2000)

# Generate dummy data
x <- 1:120
y <- paste0("Split ", seq(22,18))
data <- expand.grid(X=x, Y=y)
data$Z <- 0

data$Z[data$Y=="Split 18"] <- c(rep("Training",5),rep("h (Gap)",12),rep("v (Validation)",12), rep("i (Validation)",1),rep("v (Validation)",12),rep("h (Gap)",12),rep("Training",120-12*4-6))
data$Z[data$Y=="Split 19"] <- c(rep("Training",6),rep("h (Gap)",12),rep("v (Validation)",12), rep("i (Validation)",1),rep("v (Validation)",12),rep("h (Gap)",12),rep("Training",120-12*4-7))
data$Z[data$Y=="Split 20"] <- c(rep("Training",7),rep("h (Gap)",12),rep("v (Validation)",12), rep("i (Validation)",1),rep("v (Validation)",12),rep("h (Gap)",12),rep("Training",120-12*4-8))
data$Z[data$Y=="Split 21"] <- c(rep("Training",8),rep("h (Gap)",12),rep("v (Validation)",12), rep("i (Validation)",1),rep("v (Validation)",12),rep("h (Gap)",12),rep("Training",120-12*4-9))
data$Z[data$Y=="Split 22"] <- c(rep("Training",9),rep("h (Gap)",12),rep("v (Validation)",12), rep("i (Validation)",1),rep("v (Validation)",12),rep("h (Gap)",12),rep("Training",120-12*4-10))

# Plot heatmap 
ggplot(data, aes(X, Y, fill= Z)) + 
  geom_tile(color = "white") +
  labs(fill = "Group",x ="Period",y="")+
  theme_minimal()+
  scale_x_continuous(breaks=seq(0,120,20))+ 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ 
  theme(legend.position="bottom", plot.title = element_text(hjust = 0.5))+
  scale_fill_manual(values = c("#F8766D", "darkgreen", "#619CFF","#00BA38"))+
  ggtitle("hv-Block Cross-Validation")
ggsave("hv_block.png", width = 8, height = 4)

# 2.) Simplified Block Cross-Validation

# Generate dummy data
x <- 1:120
y <- paste0("Fold ", seq(5,1))
data <- expand.grid(X=x, Y=y)
data$Z <- 0

data$Z[data$Y=="Fold 1"] <- c(rep("Validation",24),rep("Gap",12),rep("Training",84))
data$Z[data$Y=="Fold 2"] <- c(rep("Training",12),rep("Gap",12),rep("Validation",24),rep("Gap",12),rep("Training",60))
data$Z[data$Y=="Fold 3"] <- c(rep("Training",36),rep("Gap",12),rep("Validation",24),rep("Gap",12),rep("Training",36))
data$Z[data$Y=="Fold 4"] <- c(rep("Training",60),rep("Gap",12),rep("Validation",24),rep("Gap",12),rep("Training",12))
data$Z[data$Y=="Fold 5"] <- c(rep("Training",84),rep("Gap",12),rep("Validation",24))

# Plot heatmap 
ggplot(data, aes(X, Y, fill= Z)) + 
  geom_tile(color = "white") +
  labs(fill = "Group",x ="Period",y="")+
  theme_minimal()+
  scale_x_continuous(breaks=seq(0,120,20))+ 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+ 
  theme(legend.position="bottom",plot.title = element_text(hjust = 0.5))+
  scale_fill_manual(values = c("#F8766D", "#619CFF","#00BA38"))+
  ggtitle("Simplified Block Cross-Validation")
ggsave("simplified_block.png", width = 8, height = 4)

