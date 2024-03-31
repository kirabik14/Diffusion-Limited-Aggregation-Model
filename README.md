# Diffusion-Limited-Aggregation-Model
**Diffusion-limited aggregation (DLA)** is a phenomenon in which particles, driven by Brownian motion, gradually cluster together to form larger aggregates. 
This process occurs as individual particles undergo random walks and come into contact with each other, leading to the formation of complex and often fractal-like structures.
The clusters formed in DLA processes are referred to as Brownian trees. These fractals exhibit a dimension of approximately 1.71 for free particles that are unrestricted by a lattice, however, computer simulation of DLA on a lattice will change the $fractal$ dimension slightly for a DLA in the same embedding dimension.


There can be various algorithms, but here I am giving one which I will use in the to simulate the plot in R:
1. Initialize the step length, end cluster(*possible stop points*) and end points(*actual points where walk ended*), stickiness(*probability of attaching to a cluster*); along with the boundary(*starting distance*) from which we start the random walks.
2. Now, let's say, we start a random walk from an **uniformly** chosen point from the boundary.
3. We set an **outer limit**, such that if we see the random walker getting in the opposite direction from the end cluster, we deflect it back inside the *limit radius circle*, thus increasing the probability of it reaching the end cluster.
4. We set **inner limits** (*five of them*), to restrict the movement of the walker outside the *limit radius circle* once it came into the circle, thus limiting the points it can travel to and increasing the probability of it to reach the end cluster.
5. We also add a sticking probability which determines, if and when a particle approaches the end cluster, will it attach to the cluster or continue the walk to reach another cluster
6. After the random walk finishes, we update the endpoints and the end cluster as follows:
   - the ending point is appended to the end points list.
   - the ending point should be present in the end cluster (*otherwise won't be an ending point*), which would be removed and the neighboring points of the ending point would be added in the cluster, **provided they are not already present in both end points and end cluster**.
