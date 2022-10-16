## Author
This software was written by Johannes Lachner, working in the Newman 
Laboratory for Biomechanics and Human Rehabilitation at MIT.
If you want to contribute, please send me a message: jlachner[at]mit.edu

## Short summary of files

func_addSubfolders.m: Adds subfolder "helpers" to current path. Helpers 
includes scripts for visualization, animation and calculation of 
quaternions. 

QuatInterpolation.mlx: Matlab live script that should summarize the topic 
of inerpolation for spherical displacement. The main content of this 
script is based on the paper "Coordinate-invariant rigid-body interpolation
on a parametric C1 dual quaternion curve" by Allmendinger et al. (2018)
To see the simulations in the script, please press "RUN" first.

Positions.m: Linear interpolation of positions. Results: components of 
triple are uncoupled and can be interpolated independently.

EulerAngles.m: Linear interpolation of Euler angles. Result: components
of triple are not uncoupled and should not be interpolated independently.

AxisAngle.m: Linear interpolation of rotations with axis-angle 
reprensentation. This is a simple algorithm for users that do not want to 
dive into quaternions.

SLERP_simple.m: Linear interpolation of quaternionsn by using Matlab's 
slerp-algorithm. 

SLERP_linear.m: Linear interpolation of two body-fixed coordinate frames
attached to a box. The animation should show the displacements of 
in-between interpolation poses.

SLERP_cubic.m: Extension of slerp (C^0) to cubic interpolation, using 
Bézier curves (C^1).








