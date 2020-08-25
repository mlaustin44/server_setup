import requests

def get_servers():
    nvpn_best_resp = requests.get('https://nordvpn.com/wp-admin/admin-ajax.php?action=servers_recommendations')
    return nvpn_best_resp.json()

def parse_servers(servers_json):
    for server in servers_json:
        server_id = server.get('hostname')
        for group in server.get('groups'):
            if group.get('title') == 'P2P':
                return server_id

server = parse_servers(get_servers())

print(server)