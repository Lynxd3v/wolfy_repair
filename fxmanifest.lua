fx_version 'cerulean'
game 'gta5'

author 'Mrk'
version 'v1.1'

ui_page 'web/src/index.html'

files {
    'web/src/index.html',
    'web/dist/output.css', 
    'web/src/app.js'    
}

server_script { 'server/*.*' }
client_script { 'client/*.*' }
shared_script { '@es_extended/imports.lua', 'config.lua' }

dependency {
    'es_extended',
    'ox_target'
}
