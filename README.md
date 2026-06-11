# Meus Dots
Meus arquivos de customização e scripts pensados para um fluxo de trabalho em ambiente linux minimalista que se baseia no uso de window manager e quickshell.
NOTA: As configs do SwayWM ainda não foram testadas no setup com o quickshell, é possível que haja problemas.

📦 Pacotes utilizados

• Window Manager: Niri

• Shell: Quickshell

• Terminal: Alacritty

• Editor de texto: Neovim

• Video player: MPV

• Protetor de luz azul: Gammastep

🧩 Plugins do Neovim

• Telescope (nvim-telescope)

• Alpha (goolord)

• Plenary (nvim-lua)

📜 Scripts e suas funções

• Install

- Executa um comando de instalação de pacotes que são necessários para dar compatbilidade com o ambiente de trabalho e fornece ferramentas extras de desenvolvimento (só instala caso já não estejam instalados).

- Cria links simbólicos entre as configurações e suas respectivas pastas esperadas em ".config".

- Clona a repo dos plugins do neovim.

Adendo: os seguintes scripts utilizam do rofi para fornecer a interface gráfica e mandam notificações através do notify-send (futuramente as funcionalidades serão migradas para o quickshell para uma maior integração com o ambiente).

• Wifi

- Liga ou Desliga o wifi (nmcli radio on/off).

- Realiza scan e mostra o nome da rede, força do sinal, se é protegida por senha (é necessário nerd fonts/font awesome para ver o glyph) e o tipo de proteção.

- Ao tentar se conectar, é mostrada uma confirmação e, logo em seguida, uma tela de input para digitar a senha é mostrada (ainda não implementei as validações para verificar se a senha foi inserida corretamente).

- Exibe redes conectadas e fornece ações de conectar, desconectar e esquecer/remover.
