#===============================================================================
# AEM 6850
# Monte Carlo simulations
# Biased (divide by n) vs unbiased (divide by n-1) variance estimators
#===============================================================================

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# 1). Preliminary -----
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Working directories
dir <- list()
dir$root <- dirname(getwd())
dir$output_figure <- paste(dir$root,"/output_figure",sep="")

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# 2). Main code -----
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Generate data
N <- 100000   
sig <- 1         
B <- 10000       
n.seq <- 2:50    

pop <- rnorm(N, mean = 0, sd = sqrt(sig)) # Create a population w/ mean 0 and variance 1

# Run Monte Carlo Simulation
set.seed(123)
out <- sapply(n.seq, function(n) {
  sim <- replicate(B, {
    x <- sample(pop, n, replace = FALSE)
    var_biased <- mean((x - mean(x))^2) # divide by n
    var_bessel <- sum((x - mean(x))^2) / (n - 1) # divide by n-1
    c(var_biased, var_bessel) # stores two variance estimates for every simulation
  })
  
  # Transpose the matrix for summary statistics
  sim <- t(sim)
  
  c(mean_var_biased  = mean(sim[,1]), mean_var_bessel  = mean(sim[,2]),
    Int_5_var_biased = as.numeric(quantile(sim[,1], 0.05)), Int_95_var_biased= as.numeric(quantile(sim[,1], 0.95)),
    Int_5_var_bessel = as.numeric(quantile(sim[,2], 0.05)), Int_95_var_bessel= as.numeric(quantile(sim[,2], 0.95)))
})

# Convert to data frame
out <- t(out)
out <- data.frame(n = n.seq, out)

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# 3). Plot -----
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

# Save as png
png(paste0(dir$output_figure, "/Monte_Carlo_Sim.png"), width=1800, height=1200, res=275)

par(mfrow = c(1,2), mar = c(5,5,2,1), oma = c(0, 0, 3, 0))

# Plot 1: divided by n
plot(out$n, out$mean_var_biased, type="l", lwd=2, col="black", xaxt="n", ylim=c(0,2), xlab="Sample size (n)", ylab="Estimate",
     main="Divided by n", las=1, cex.main = 0.9, font.main=1) # where out$n is x-axis and out$mean_var_biased is y-axis

axis(1, at = c(2,10,20,30,40,50), labels = c(2,10,20,30,40,50))
polygon(c(out$n, rev(out$n)), c(out$Int_5_var_biased, rev(out$Int_95_var_biased)), col=gray(0.85), border=NA)

# Draw True value and Mean estimate
lines(out$n, out$mean_var_biased, lwd=2, col="black")
segments(x0=min(out$n), y0=1, x1=max(out$n), y1=1, col="red", lty=2)

# Legend
legend(x = 25, y = 0.4, legend = c("True value", "Mean estimate"), col = c("red", "black"), lty = c(2,1), 
       seg.len = 4, bty = "n", cex = 0.5, x.intersp = 0.5, y.intersp = 1) 

# Plot 2: divided by n-1
plot(out$n, out$mean_var_bessel, type="l", lwd=2, col="black", xaxt="n", ylim=c(0,2), xlab="Sample size (n)", ylab="Estimate",
     main="Divided by n-1", las=1, cex.main = 0.9, font.main=1)

# Set polygon to stay within y-limits
ymin <- 0
ymax <- 2.075
y_lower <- pmax(out$Int_5_var_bessel, ymin)
y_upper <- pmin(out$Int_95_var_bessel, ymax)

axis(1, at = c(2,10,20,30,40,50), labels = c(2,10,20,30,40,50))
polygon(c(out$n, rev(out$n)), c(y_lower, rev(y_upper)), col=gray(0.85), border=NA)

lines(out$n, out$mean_var_bessel, lwd=2, col="black")
segments(x0=min(out$n), y0=1, x1=max(out$n), y1=1, col="red", lty=2)

# Add title
mtext("Comparing Estimators of the Population Variance", outer = TRUE, cex = 1.4, font = 2)

dev.off()

