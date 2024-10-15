require('lspconfig')['sqls'].setup {
  on_attach = function(client, bufnr)
    require('sqls').on_attach(client, bufnr)
  end,
  settings = {
    sqls = {
      connections = {
        { driver = 'oracle', dataSourceName = 'cprg250/password@localhost:1521/XE' },
      },
    },
  }
}

local function getf()
    return vim.api.nvim_buf_get_name(0);
end

function string:endswith(suffix)
    return self:sub(-#suffix) == suffix
end

local function getT()
    local fn = getf()
    return fn:gsub("/storage/oracle", "/host")
end

function OpenTerm()
    local fn = getf()
    local nfn = getT()
    if fn:endswith(".sql") then
        vim.cmd('TermExec direction=float cmd="docker exec -it oracle sqlplus cprg250/password@localhost:1521/XE @' .. nfn ..'"')
        -- vim.cmd('TermExec direction=float cmd="docker exec -it oracle sqlplus SYS/123456@localhost:1521/XE as SYSDBA @' .. nfn ..'"')
    else
        vim.cmd('ToggleTerm direction=float')
    end
end

vim.api.nvim_set_keymap('n', '<c-m-t>', ':lua OpenTerm()<cr>', {})

Plantuml_path = ""
Plantuml_buffer = {}

local function getName()
    local bufnr = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    return filepath
end


local function getBaseName()
    return vim.fn.fnamemodify(getName(), ':r:t')
end

local function getPreviewName()
    return getBaseName() .. '.atxt'
end

local function getPngName()
    return getBaseName() .. '.png'
end

function Preview()
    vim.system({'plantuml', getName(), '-atxt'}):wait()
    vim.cmd('e ' .. getPreviewName())
end

function PlugUml()
    if Plantuml_path == '' then
        local p = os.getenv("PLUG_PUML_PATH")
        if p then
            Plantuml_path = p
        else
            Plantuml_path = vim.system({'nix', 'eval', '--raw', 'nixpkgs#vimPlugins.plantuml-syntax.outPath'}):wait().stdout;
        end
    end

    local uml_exts = {"*.pu", "*.uml", "*.plantuml", "*.puml", "*.iuml"}
    vim.api.nvim_create_autocmd('BufRead', {
        pattern = uml_exts,
        callback = function()
            vim.bo.filetype = "plantuml"
            vim.cmd('source ' .. Plantuml_path .. '/ftplugin/plantuml.vim')
            vim.cmd('source ' .. Plantuml_path .. '/indent/plantuml.vim')
            vim.cmd('source ' .. Plantuml_path .. '/syntax/plantuml.vim')
            vim.cmd('nnoremap <buffer> <leader><space> :lua Preview()<cr>')
            vim.cmd('nnoremap <buffer> <leader>o :!plantuml ' .. getName() .. '<cr>')
        end,
    })
end

PlugUml()

