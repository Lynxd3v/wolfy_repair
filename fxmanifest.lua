fx_version 'cerulean'
game 'gta5'

author 'Mrk'
version 'v0.1'

server_script {'server/*.*'}
client_script {'client/*.*'}
shared_script {'@es_extended/imports.lua','config.lua'}

dependency {
    'es_extended',
    'ox_target'
}