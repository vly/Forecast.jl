@recipe function f(fCCF::CCF)

    # plot configuration
    legend:= false

    titlefont:= font(8, "Courier")
    xtickfont:= font(3, "Courier")
    ytickfont:= font(3, "Courier")
    yguidefont:= font(5, "Courier")
    xguidefont:= font(5, "Courier")

    N = fCCF.N
    type = (fCCF.type == "cor") ? "Correlation" : "Covariance"
    auto_prefix = fCCF.auto ? "Auto" : "Cross"
    yguide := auto_prefix*'-'*type
    xguide := "Lag"
    
    # Center ticks
    lr = length(fCCF.ccf)
    gap = div(lr,11)
    mp = div(lr+1,2)
    rs = mp:gap:lr
    ls = mp-gap:-gap:1

    if fCCF.auto
        xticks := 1:gap:lr
    else
        xt = vcat(reverse(collect(ls)),collect(rs))
        xticks := (xt, xt .- xt[div(end+1,2)])
    end
    
    @series begin
        seriestype := :sticks
        ymirror := false
        guide_position := :left
        linewidth := 100/(fCCF.lag+1)
        fCCF.ccf
    end

    if fCCF.type == "cor"
        lg = fCCF.lag
        a1 = fCCF.alpha[1]; c1 = fCCF.ci[1]
        a2 = fCCF.alpha[2]; c2 = fCCF.ci[2]
        dc = c2-c1

        @series begin
            seriestype := :hline
            seriescolor := :black
            linealpha := 0.5
            linestyle := :dash
            [-c1,c1]
        end

        @series begin
            seriestype := :hline
            seriescolor := :black
            linealpha := 0.5
            linestyle := :dot
            ax = fCCF.auto ? lg : 2*lg + 1
            annotations := 
                [(ax,c1+dc/8,string("CI %",a1*100),font(3, "Courier")),
                 (ax,c2+dc/8,string("CI %",a2*100),font(3, "Courier"))]
            [-c2,c2]
        end
    end
end 

@recipe function f(fSTL::STL)

    # subplots configuration
    legend:= false
    grid:= false
    layout := @layout [Data
                       Seasonal
                       Trend
                       Remainder]
    
    xtickfont:= font(3, "Courier")
    ytickfont:= font(3, "Courier")
    yguidefont:= font(5, "Courier")

    # reference bar
    a,b = extrema(skipmissing(values(fSTL.ta[:Seasonal].+
                                     fSTL.ta[:Trend].+
                                     fSTL.ta[:Remainder]))); hd = b-a
    a,b = extrema(skipmissing(values(fSTL.ta[:Seasonal]))); hs = b-a
    a,b = extrema(skipmissing(values(fSTL.ta[:Trend]))); ht = b-a
    a,b = extrema(skipmissing(values(fSTL.ta[:Remainder]))); hr = b-a
    mh = min(hd,hs,ht,hr)

    inset_subplots := [(1, bbox(-0.012, 0, 0.01, 1.0, :left)),
                       (2, bbox(-0.012, 0, 0.01, 1.0, :right)),
                       (3, bbox(-0.012, 0, 0.01, 1.0, :left)),
                       (4, bbox(-0.012, 0, 0.01, 1.0, :right))]

    @series begin
        subplot := 1
        yguide := "Data"
        xaxis := nothing
        bottom_margin := -7Plots.mm    
        fSTL.ta[:Seasonal] .+ fSTL.ta[:Trend] .+ fSTL.ta[:Remainder]
    end

    @series begin
        subplot := 2
        yguide := "Trend"
        xaxis := nothing
        ymirror:=true
        guide_position:=:left
        bottom_margin := -7Plots.mm    
        fSTL.ta[:Trend]
    end

    @series begin
        subplot := 3
        yguide := "Seasonal"
        xaxis := nothing
        seriestype := :sticks
        bottom_margin := -7Plots.mm    
        fSTL.ta[:Seasonal]
    end

    @series begin
        subplot := 4
        yguide := "Remainder"
        seriestype := :sticks
        #bottom_margin:=0Plots.mm    
        ymirror:=true
        guide_position:=:left
        fSTL.ta[:Remainder]
    end

    @series begin
        subplot := 5
        background_color_inside := nothing
        framestyle := :none
        seriestype := :bar
        ylims := (0,hd)
        mh:mh
    end

    @series begin
        subplot := 6
        background_color_inside := nothing
        framestyle := :none
        seriestype := :bar
        ylims := (0,ht)
        mh:mh
    end
    
    @series begin
        subplot := 7
        framestyle := :none
        seriestype := :bar
        ylims := (0,hs)
        mh:mh
    end

    @series begin
        subplot := 8
        framestyle := :none
        seriestype := :bar
        ylims := (0,hr)
        mh:mh
    end

end
