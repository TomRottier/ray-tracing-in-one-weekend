using Images, Term.Progress

function main()
    width = 256
    height = 256

    output = Matrix{RGB}(undef, height, width)

    @track for i in 1:width
        for j in 1:height

            r = (i - 1) / (width - 1)
            g = (j - 1) / (height - 1)
            b = 0.25

            # reverse index to plot in same direction
            jj = reverse(1:height)[j]
            output[jj, i] = RGB(r, g, b)
        end
    end

    return output
end

main()