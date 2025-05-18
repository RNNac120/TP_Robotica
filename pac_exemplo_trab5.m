clc; clear all; close all;

pkg load image;
pkg load statistics;
pkg load pythonic;
py.sys.path.append('/home/rnn120/.local/lib/python3.11/site-packages')

% Botões
Nada   = [0 0 0 0 0 0 0 0 0]; % Nada
A_btn  = [1 0 0 0 0 0 0 0 0]; % Ataque
Z_btn  = [0 1 0 0 0 0 0 0 0]; % Nada?
Select = [0 0 1 0 0 0 0 0 0];
Start  = [0 0 0 1 0 0 0 0 0]; % Iniciar
Up     = [0 0 0 0 1 0 0 0 0];
Down   = [0 0 0 0 0 1 0 0 0];
Left   = [0 0 0 0 0 0 1 0 0];
Right  = [0 0 0 0 0 0 0 1 0];
B_tn   = [0 0 0 0 0 0 0 0 1]; % Pulo

% Função para capturar a tela do jogo
function [tela] = captura_tela(jogo)
	img = jogo.get_screen();
	py.cv2.imwrite('teste.bmp', img);
	tela = imread('teste.bmp');
	if size(tela, 3) == 3
		tela = tela(: , : , 3:-1:1); 
	end
end

% Função para apertar o botão por alguns frames
function aperta_botao(jogo, botao, duracao)
    for i = 1 : duracao
        jogo.set_button_mask(botao);
        jogo.step();
        tela = captura_tela(jogo);
        imshow(tela);
        drawnow;
    end

    % Soltar o botão, só pra garantir
    jogo.set_button_mask(zeros(1, 9));
end

function tela = avanca_tela(jogo, frames, desenha)
    for i = 1 : frames
        tela = captura_tela(jogo);
        if strcmp(desenha, "sim")
            imshow(tela);
            drawnow;
        end
        jogo.step();
    end
    jogo.get_state();
end

function robo = atracao(robo, alvo, K)
    robo = robo + K * (alvo - robo);
end

% Inicia o emulador
if ~exist('jogo')
    global jogo = py.retro.RetroEmulator("Bubble Bobble (USA).nes");

    % % Espera a tela inicial carregar
    % for i = 1 : 270
    %     tela = captura_tela(jogo);
    %     imshow(tela);
    %     jogo.step();
    %     drawnow;
    % end
    % 
    % fprintf("Passei a intro\n");
    %
    % % Para entrar no jogo
    % aperta_botao(jogo, Start, 10);
    %
    % % Passar alguns frames
    % for i = 1 : 30
    %     jogo.step();
    % end
    %
    % aperta_botao(jogo, Start, 10);
    %
    % for i = 1 : 270
    %     tela = captura_tela(jogo);
    %     imshow(tela);
    %     jogo.step();
    % end
    % 
    % % Salva o estado
    % state_game = jogo.get_state();

    % Espera a intro do jogo passar
    tela = avanca_tela(jogo, 270, "não");

    % Para entrar no jogo
    aperta_botao(jogo, Start, 10);

    % Avança a tela????
    tela = avanca_tela(jogo, 10, "sim");

    % Inicia o jogo
    aperta_botao(jogo, Start, 10);

    % Estamos no jogo
    tela = avanca_tela(jogo, 550, "não");
    tela_gray = rgb2gray(tela);

    u = unique(tela_gray)

    Bub = tela_gray == u(3) | tela_gray == u(4) | tela_gray == u(9);
    Ini = tela_gray == u(2) | tela_gray == u(5) | tela_gray == u(7);
    imshow(Bub | Ini);
    drawnow
    pause(10)

    % Aqui tudo vai ser feito
    % while true
    %     
    % end
    % aperta_botao(jogo, A_btn, 5);
    %
    % % Acho que a partir daqui pode começar o programa mesmo
    % avanca_tela(jogo, 50, "sim");
end

%
% % ????
% while true
%     jogo.step();
%     tela = captura_tela(jogo);
%     imshow(tela);
%     drawnow;
% end
%
% fprintf("Saí do terceiro for\n");
%
% jogo.set_button_mask(Start);
% for i = 1 : 100
%     jogo.step();
%     tela = captura_tela(jogo);
%     imshow(tela);
%     drawnow;
% end
% fprintf("Saí do \033[1;31mquarto\033[m for\n");
