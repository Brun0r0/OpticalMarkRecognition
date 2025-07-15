% Autores:
    % Gabriel C. Brunoro
    % Pedro F. Sabino

%Limpeza
clear, clc, close all;

%Colocar o arquivo gabarito na pasta /templates/
gabaritoName = input("Enter the name of the template: ", 's');

caminho = 'templates/' + string(gabaritoName) + '.txt';

% Lê o gabarito e aloca na array gabarito
gabarito = ler_gabarito(caminho);

% Leitura das folhas respostas na pasta
caminho = "Answer sheets/";
files = dir(caminho + "*.j*eg");

qntFolhas = length(files);

nomes = {};
notas = [];

% Criação de uma planilha
planilhaNotas = table(nomes, notas);

% Iteração para cada folha
for k = 1:qntFolhas
    try
        arqName = files(k).name;

        [~, baseName, ~] = fileparts(arqName);

        imagem = imread(caminho + arqName);
        
        % Correção de inclinação
        imagem_rotacionada = corrigir_inclinacao(imagem);
        
        % Secciona figura principal
        imagem_MO = recortar_MOs(imagem_rotacionada);
        
        % Identificação das respostas
        respostas = identificar_respostas(imagem_MO);
        title(baseName);
    
        % Corrigir a prova
        notaFinal = corrigir_prova(gabarito, respostas, baseName);
        
        % Adicionando a planilha
        novaLinha = {baseName, notaFinal};
        planilhaNotas(end+1, :) = novaLinha;

    catch
        fprintf("Erro no arquivo: %s\n\n", arqName);
    end
end

% Salvando planilha "Notes"
writetable(planilhaNotas, "Notes/All.xls");

disp(planilhaNotas);
