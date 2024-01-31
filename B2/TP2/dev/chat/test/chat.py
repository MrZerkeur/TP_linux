import asyncio
import os
import logging


global HOST 
HOST = "127.0.0.1"
global PORT
PORT = int(os.getenv("CHAT_PORT", 8888))
global MAX_USERS
MAX_USERS = int(os.getenv("MAX_USERS", 16))
global CLIENTS
CLIENTS = {}


async def handle_client_msg(reader, writer):
    logger = logging.getLogger("colored_logger")
    logger.setLevel(logging.INFO)

    formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)

    logger.addHandler(console_handler)
    
    data = await reader.read(1024)
    pseudo = ""
    if data.decode()[:5] == "Hello":
        pseudo = data.decode()[6:]
        
    if len(CLIENTS) == MAX_USERS:
        writer.write(f"Le nombre maximum d'utilisateur est {MAX_USERS} et a été atteint, veuillez réessayer plus tard".encode())
        return
    
    addr = writer.get_extra_info('peername')
    if addr not in CLIENTS.keys():
        CLIENTS[addr] = {}
        CLIENTS[addr]["r"] = reader
        CLIENTS[addr]["w"] = writer
        CLIENTS[addr]["pseudo"] = pseudo
        
    for client in CLIENTS:
        if client != addr:
            CLIENTS[client]["w"].write(f"Annonce : {pseudo} a rejoint la chatroom".encode())
            await CLIENTS[client]["w"].drain()

    logger.info(f"Un nouveau client {addr} s'est connecté, son pseudo est : {pseudo}")
    
    while True:
        print("oui")
        data = await reader.read(1024)
        print("encore oui")
        client_host, client_port = addr

        if data == b'':
            CLIENTS.pop(addr)
            for client in CLIENTS:
                logger.info(f"{pseudo} ({client_host}:{client_port}) a quitté la chatroom")
                CLIENTS[client]["w"].write(f"Annonce : {pseudo} a quitté la chatroom".encode())
                await CLIENTS[client]["w"].drain()
            continue

        message = data.decode()
        logger.info(f"Message reçu de {client_host}:{client_port} : {message}")
        
        for client in CLIENTS:
            if client != addr:
                CLIENTS[client]["w"].write(f"{pseudo} a dit : {message}".encode())
                await CLIENTS[client]["w"].drain()

        

async def main():
    server = await asyncio.start_server(handle_client_msg, HOST, PORT)

    addrs = ', '.join(str(sock.getsockname()) for sock in server.sockets)
    
    logger = logging.getLogger("colored_logger")
    logger.setLevel(logging.INFO)

    formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)

    logger.addHandler(console_handler)
    logger.info(f'Serveur tourne sur {addrs}')

    async with server:
        await server.serve_forever()

if __name__ == "__main__":
    asyncio.run(main())