## Desc: a script to plot two dataframes by using Girko's circular Law as an example. /nSaves the output to `../Results/Girko.pdf`

build_elipse <- function(hradius, vradius) {# function that returns an ellipse
    npoints = 250
    a <- seq(0, 2 * pi, length = npoints + 1)
    x <- hradius * cos(a)
    y <- vradius * sin(a)
    return(data.frame(x = x, y = y))
}

N <- 250
M <- matrix(rnorm(N * N), N, N)
eigvals <- eigen(M)$values # find eigen values
eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals)) #Build a dataframe 
my_radius <- sqrt(N) # The radius of the circle is sqrt(N)
ellDF <- build_elipse(my_radius, my_radius) # Dataframe to plot the ellipse
names(ellDF) <- c("Real", "Imaginary") # rename the columns

# plot the eigenvals
p <- ggplot(eigDF, aes(x = Real, y = Imaginary))
p <-  p + geom_point(shape = I(3)) + theme(legend.position = "none")


# now add the vertical and horizontal line
p <- p + geom_hline(aes(yintercept = 0))
p <- p + geom_vline(aes(xintercept = 0))


# finally add the ellipse
p <- p + geom_polygon(data = ellDF, aes(x = Real, y = Imaginary, alpha = 1/20, fill = "red"))
p
pdf("../Results/Girko.pdf")
    print(p)
    graphics.off()
    