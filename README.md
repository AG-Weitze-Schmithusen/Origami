# README file for the GAP package Origami

This package provides calculations for origamis, also called square-tiled surfaces. This are translation surfaces, obtained by gluing the edges of squares. These surfaces can equivalently be described as coverings of a torus. 
This package calcultates basic properties of origamis as stratum and genus. The main feature of the package is the calculation of Vech groups of origamis.

## Using the package

Copy the package in the pkg directory of your GAP directory. Then start GAP and enter: 

 LoadPackage( "Origami" );

## Needed packages

You need the following GAP packages, to use this package:

- ModularGroup Version 0.0.1 (https://AG-Weitze-Schmithusen.github.io/ModularGroup/)

- Orb Version 4.7.6 (this is a standard package)

To use the SageMath functions from the surface_dynamics package you also need the following packages:

- HomalgToCAS Version2018.06.15 

- IO_ForHomalg Version 2017.09.02

- IO Version 4.5.1

- RingsForHomalg Version 2018.04.04

## Using SageMath

There is a SageMath package "surface_dynamics" from Samuel Lelièvre and Vincent Delecroix, which contains similar functionality as this GAP package. Our package includes an interface to SageMath, that allows to use calculations from the SageMath package surface_dynamics in a GAP session. To use them, SageMath  and the SageMath package surface_dynamics (https://pypi.org/project/surface_dynamics/) must be installed on your operation system. 


