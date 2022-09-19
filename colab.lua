

function colab(args, kwargs, meta)
    local dir = meta["nb_copy_dir"]
    quarto.log.output('debug info')
    return pandoc.utils.stringify(dir)
end