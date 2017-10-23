# Code is in GitHub repository

# This follwing code sources a function “script_with_functions_2.R”, which contains a bunch of useful functions for plotting the data. These functions are included at the bottom of this page. As a result, our analysis script: 

# is much shorter and more readable than the messy code.
# is less likely to contain bugs, because it maintains a clean workspace, and each bit of code is only written once
# does a lot more, with just a few more lines of code. By combining the functions we can make many more plots, much faster.

# ------------------------------------------------ # 

rm(list=ls(all=TRUE)) #start with empty workspace

source("script-fun.R")

data <- load.data()

## Plot Mass against Longevity for Carnivora and for Chiroptera
plot.pair(data, "Mass", "Longevity", "Carnivora")
plot.pair(data, "Mass", "Longevity", "Chiroptera")

## Construct a new plot by reuising primatives
cols <- c(Carnivora="#eaab00",
          Chiroptera="#803d0d",
          Artiodactyla="#cc0033",
          Rodentia="#5c705e",
          Diprotodontia="#56364d")
plot(Longevity ~ Mass, data, log="xy", type="n",
     xlab="Body mass (g)", ylab="Longevity (years)", las=1)
add.bg.points(data, "Mass", "Longevity", "grey")
for ( order in names(cols) )
  add.order(data, "Mass", "Longevity", order, make.transparent(cols[[order]]))
legend("bottomright", names(cols), fill=make.transparent(cols), bty="n")


## Define new functions to combine plots,
## e.g. create a matrix of plots

## Plots a matrix of bivariate plots, highlighting a given order 
plotMatrix<-function(data, vars, order, 
                     col.focus=make.transparent("blue", .2), 
                     mar=c(5, 5, 0.5, 0.5), 
                     oma=c(0.5, 0.5, 0.5, 0.5)) {
  par(mfrow=c(length(vars), length(vars)), mar=mar, oma=oma)
  for (i in vars) {
    for (j in vars) {
      if (i != j)
        plot.pair(data, i, j, order, col.focus=col.focus)               
      else
        plot.new()
    }
  }    
}

vars<-names(data)

pdf("Matrix.plot.pdf", height =12, width=12)
plotMatrix(data, vars[6:10], "Carnivora")
dev.off()

## Scale up - repeat for all orders.
for (order in names(cols)) {
  pdf(paste0("Matrix.plot-", order,".pdf"), height =12, width=12)
  plotMatrix(data, vars[6:10], order, col.focus = make.transparent(cols[[order]]))
  dev.off()  
}
