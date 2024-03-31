#set.seed(2024)
library(tidyverse)
library(viridis)


##Initialization
step_value= c(1, -1, 1i, -1i)
end_cluster= c(0)
end_points= c()
stickiness= 0.2


##Boundary Values (Taxicab)
distance= 100
boundary_values= c(distance, -distance, 
                   distance *1i, -distance *1i)
boundary_point= boundary_values[3]
for(addends in 1:(distance -1)) {
  boundary_point=  boundary_point +1 -1i
  boundary_points= c(boundary_point, Conj(boundary_point),
                     -boundary_point, -Conj(boundary_point))
  boundary_values <- append(boundary_values, boundary_points)
}

outer_limit= floor(1.25 *distance)
inner1_limit= ceiling(0.5 *distance)
inner2_limit= ceiling(0.25 *distance)


##Boundary Restriction
check_limit <- function(point) {
  probable_steps= step_value
  if(Mod(point) <= inner2_limit) {
    for(step in step_value) {
      new_point= point +step
      if(Mod(new_point) >= inner2_limit) {
        probable_steps <- probable_steps[probable_steps != step]
      }
    }
  } else if(Mod(point) <= inner1_limit) {
    for(step in step_value) {
      new_point= point +step
      if(Mod(new_point) >= inner1_limit) {
        probable_steps <- probable_steps[probable_steps != step]
      }
    }
  } else if(Mod(point) <= outer_limit) {
    for(step in step_value) {
      new_point= point +step
      if(Mod(new_point) >= outer_limit) {
        probable_steps <- probable_steps[probable_steps != step]
      }
    }
  } 
  return(probable_steps)
}


##End Cluster Modification
end_cluster_modify <- function(end_point) {
  end_cluster <- end_cluster[end_cluster != end_point]
  for(step in step_value) {
    new_point= end_point +step
    if(! new_point %in% end_cluster && 
       ! new_point %in% end_points) {
      end_cluster <- append(end_cluster, new_point)
    }
  }
  return(end_cluster)
}


##Random Walk
walks= 1
for(rw in 1:walks) {
  print(rw)
  position= sample(border, 1)
  while(TRUE) {
    print(position)
    step= sample(check_limit(position), 1)
    position= position +step
    if(!position %in% end_cluster) {
      stick_prob= runif(1, min= 0, max= 1)
      if(stick_prob< stickiness) {
        break
      }
    }
  }
  end_points <- append(end_points, position)
  end_cluster= end_cluster_modify(position)
}


##Plotting
ggplot() +
  geom_point(mapping= aes(x= Re(end_points), y= Im(end_points)),
             color= turbo(length(end_points)),
             show.legend= FALSE, size= 0.8) +
  theme(
    panel.background= element_rect(fill= "black"),
    panel.grid= element_blank(),
    panel.border= element_blank(),
    axis.title= element_blank(),
    axis.ticks= element_blank(),
    axis.text= element_blank()
  )

