# Lattice Boltzmann Method (In progress)

Here is an example of simulation of the lid-driven cavity problem using the Lattice Boltzmann Method, a numerical hydrodynamics algorithm, stemming from kinetic theory.

# Theory

A classical system of interacting particles can be descrived at different levels. We can start from the Hamiltonian describing the particles, but it is not particularly enlightening. If we put additional cosntraints and abstractions, we can write down equations for the dynamics of the macroscopic variables, completely washing out the particle picture. The Navier-Stokes equation describing the evolution of Newtonian fluids operate at this regime. 

Kinetic theory introduced a mesoscopic scale into this picture, in between the previous two scales, where some new physics can be found. The Boltzmann equation provides a statistical description for out of equilibrium systems, given by,

$$ \frac{\partial f}{\partial t} + \frac{\boldsymbol{p}}{m} \cdot \nabla f + \boldsymbol{F} \frac{\partial f}{\partial \boldsymbol{p}} = \left( \frac{\partial f}{\partial t} \right)_{coll}, $$

where $f$ is the single particle distribution in phase space described by the coordinates $\boldsymbol{r}$ and $\boldsymbol{p}$, $\boldsymbol{F} \left( \boldsymbol{r}, t \right)$ is the force field, and the RHS gives the change of the distribution due to colissions.

The idea behind the Lattice Boltzmann method is that a discretized version of the Botlzmann equation with an ad-hoc colission term can descrive the evolution of the velocity field of a Newtonian incopressible fluid described by the Navier-Stokes equation. The approximation is reasonably accurate for low Reynolds number flows.

## Algorithm

We us the D2Q9 discretization in 2-dimensions, where there $9$ directions (including staying still) for the distribution to move on a grid. **Figure 1** shows the directions.

The density and the velocity field can be recovered as moments of this $9$ dimensional distribution as,

$$ \rho \left( \boldsymbol{r}, t \right) =  \sum_{i = 0}^{8} f_{i} \left( \boldsymbol{r}, t \right) \text{, and,}$$
$$ \boldsymbol{u} \left( \boldsymbol{r}, t \right) = \frac{c}{\rho} \sum_{i = 0}^{8} \boldsymbol{e}_{i} f_{i} \left( \boldsymbol{r}, t \right), $$

where $\boldsymbol{e}_{i}$ is the direction associated with the $i\text{-th}$ distribution and $c = \frac{\Delta x}{\Delta t}$ is determined from the space and time discretizations.

The algorithm only involves array movements and arithmetic unlike other numerical hydrodynamics techniques. It cosnists of the streaming and colission steps and revovering $\rho \text{ and } \boldsymbol{u}$ after doing this.

### 1. Streaming

The streaming step is just translating the distributions in their respective directions.
<center>

<div style="display:inline-block;">
  <img style="width:200px;float:left;" src="before_streaming.png"/>
  <img style="width:200px;float:left;" src="after_streaming.png"/>
</div> 

  <b>Figure 1.</b> The streaming step
</center>


### Collision

In the colission step the distributions are corrected to incorporate the local interactions through colissions, given by,

$$ \Delta f_{i} \left( \boldsymbol{r}, t \right) = \frac{ f_{i} \left( \boldsymbol{r}, t \right) - f_{i}^{eq} \left( \boldsymbol{r}, t \right) }{\tau} .$$

$\tau$, the relaxation time (analogous to the time scale of colissions in kinetic theory), is a simulation parameter, and the equilibrium distribution,

$$ f_{i}^{eq} \left( \boldsymbol{r}, t \right) = w_{i} \rho \left( 1 + \left[ 3 \frac{\boldsymbol{e_{i}} \cdot \boldsymbol{u}}{c} + \frac{9}{2} \frac{ \left( \boldsymbol{e_{i}} \cdot \boldsymbol{u} \right)^{2}}{c^{2}} - \frac{3}{2} \frac{|\boldsymbol{u}|^{2}}{c^{2}} \right] \right) .$$

The weights, $w_{i}$, are $0$ for $i = 0$, $\frac{1}{9}$ for $i = 1, 2, 3, 4,$ and $\frac{1}{36}$ for $i = 5, 6, 7, 8.$ 

## Reynold's Number

The simulation parameters control the Reynold's number, $Re$, through the kinematic viscosity,

$$ \nu = \frac{2 \tau -1}{6} \frac{\left( \Delta x \right)^{2}}{\Delta t}, $$
 
$Re = \frac{uL}{\nu}.$

Please not that the simulation will fail to remain incompressible as $Re$ increases. Also, it can become unstable for some values of $\tau$ and the choices of grid spacings.

## Example simulation

This is an example simulation of the Lid-Driven cavity, with the boundary conditions $\boldsymbol{u} \left( y = L  \right) = u_{0}$ and reflecting boundary conditions on the other three boundaries of a square of length $L$. Zou-He (see [On pressure and velocity flow boundary conditions for the lattice Boltzmann BGK model](https://arxiv.org/abs/comp-gas/9508001)) technique is used to enforece the top boundary condition. Reflective boundary conditions are easily employed by reflecting the $f_{i}$ s appropriately on the boundaries during the streaming step.

<center>
  <figure style="display:block margin: 0 auto 0.55em;">
      <img style="width:500px" src="Flow 1950.75.gif">
  </figure>
</center>
