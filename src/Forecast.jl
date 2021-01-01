module Forecast

using CSV, Distributions, DataFrames, LinearAlgebra, Plots, RecipesBase, TimeSeries, Statistics

# types
export STL
# methods
export ccf, d, loess, sma, stl
# datasets
export co2

# source files
include("loess.jl")
include("sma.jl")
include("stl.jl")
include("d.jl")
include("ccf.jl")

include("utils.jl")

include("datasets.jl")

## recipes
include("plotrecipes.jl")

"""
Collection of methods for Time Series analysis

Methods implemented:

    d:          Lagged differences of a given order for Vector, Array and TimeSeries.
    loess:      Locally weighted smoothed series.
    sma:        Simple moving average.
    stl:        Seasonal and Trend decomposition using loess.
"""
Forecast

end
