% ------------------------------------------------------------
% Sistema de Correção Automática de Provas OMR
% 
% Este script realiza a leitura e análise de folhas de resposta
% de provas do tipo múltipla escolha utilizando técnicas de 
% reconhecimento óptico de marcas (OMR). Através do processamento 
% de imagem, identifica as alternativas marcadas, compara com o 
% gabarito e gera as notas automaticamente.
% ------------------------------------------------------------
% Como utilizar:
%   1º Adicionar um arquivo gabarito no formato .txt como está no
%        arquivo gabarito_exemplo.txt
%   2º Adicionar as fotos das folhas respostas na pasta Folhas_Respostas
%   3º Rodar o arquivo main.m e responder qual é o gabarito que deseja
%       utilizar para a correção
%   4º Os resultados estarão armazenados na pasta Notas
% ------------------------------------------------------------
% Autor:
%   Gabriel C. Brunoro

%Limpeza
clear, clc, close all;

%Colocar o arquivo gabarito na pasta /gabaritos/
gabaritoName = input("Digite o nome do gabarito: ", 's');

caminho = 'templates/' + string(gabaritoName) + '.txt';

% Lê o gabarito e aloca na array gabarito
gabarito = ler_gabarito(caminho);

% Adicionar todas folhas respostas na pasta correspondente
% Leitura das folhas respostas


% Lista de extensões suportadas
extensoes = ["*.jpg", "*.jpeg", "*.png", "*.bmp", "*.tif", "*.tiff"];

caminho = "Answer sheets/";
files = [];

% Buscar arquivos com cada extensão
for i = 1:length(extensoes)
    files = [files; dir(fullfile(caminho, extensoes(i)))];
end

% Realiza a contagem de arquivos da pasta
qntFolhas = length(files);

% Inicialização de arrays
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

        % Descomentar para ver imagem de entrada
        %figure, imshow(imagem);
        
        % Correção de inclinação
        imagem_rotacionada = corrigir_inclinacao(imagem);
        
        % Descomentar para ver imagem rotacionada
        %figure, imshow(imagem_rotacionada);
        
        % Secciona figura principal
        imagem_MO = recortar_MOs(imagem_rotacionada);

        % Descomentar para ver imagem recortada
        %figure, imshow(imagem_MO);
        
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

% Salvando planilha "Notas"
writetable(planilhaNotas, "Notes/all.xls");

disp(planilhaNotas);