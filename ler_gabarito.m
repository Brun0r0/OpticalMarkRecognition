function gabarito = ler_gabarito(caminho)
 
    arquivo = fopen(caminho, 'r');
    
    % Lê cada linha como string
    linhas = textscan(arquivo, '%s', 'Delimiter', '\n');
    fclose(arquivo);
    
    % Extrai linhas
    linhas = linhas{1};
    
    % Inicializa variáveis
    numeros = zeros(length(linhas), 1);
    pesos   = zeros(length(linhas), 1);
    
    % Mapeamento de letras para números
    mapa = containers.Map({'a','b','c','d','e'}, 1:5);
    
    % Processa linha por linha
    for i = 1:length(linhas)

        % Separa por '-'
        partes = strsplit(linhas{i}, '-');

        % Pega letra (remove espaços)
        letra = lower(strtrim(partes{1}));

        % Converte peso para número
        peso = str2double(strtrim(partes{2}));  
    
        if isKey(mapa, letra)
            numeros(i) = mapa(letra);
            pesos(i)   = peso;
        else
            error('Letra inválida na linha %d: %s', i, letra);
        end
    end
    
    % Cria matriz final [50x2]
    gabarito = [numeros pesos];
end