local str = pandoc.utils.stringify
local file = quarto.doc.project_output_file()
local colab_prefix = 'https://colab.research.google.com/github/'
local colab_badge = pandoc.Image('', 'https://colab.research.google.com/assets/colab-badge.svg', 'Open in Colab')


local function branch(meta)
    -- get the target repo's branch giving precedence to the colab: branch field, but defaulting to website: repo-branch
    local branch = meta['colab.branch']
    local web_branch = meta['website.repo-branch'] -- value set by automatically by nbdev
    if branch == nil  and web_branch ~= nil then branch = web_branch else branch = 'main' end
    return str(branch):gsub('/$', '')..'/'
end

local function repo(meta)
    -- get the name of the repo giving predence to the colab: github-repo field, but defaulting to parsing the website: repo-url field
    local repo = meta['colab.github-repo']
    local web_repo = meta['website.repo-url'] -- value set by automatically by nbdev
    if repo == nil and web_repo ~= nil then
        repo = str(web_repo):gsub('https://github.com/', '')
    end
    return str(repo):gsub('/$', '')..'/'
end

local function subdir(meta)
    -- get the directory of the exported notebook
    local nbdir = meta['colab.exported-dir']
    if nbdir == nil then return '' 
    else return str(nbdir):gsub('/$', '')..'/' 
    end
end

function colab(args, kwargs, meta)
    -- construct the colab badge
    if quarto.doc.isFormat('ipynb') then
        local path = repo(meta)..'blob/'..branch(meta)..subdir(meta)..file
        return pandoc.Link(colab_badge, colab_prefix .. path)
        -- return '<a href="'..colab_prefix..path..'"rel="nofollow">'..colab_img..'</a>'
    end
end
