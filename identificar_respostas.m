function respostas = identificar_respostas(imagem)

    % Redimensionamento da imagem
    imagem = imresize(imagem, [808 544]);

    % Binarização com Otsu
    level = graythresh(imagem);
    img_bw = imbinarize(imagem, level+0.1);

    % Processo de erosão -> Melhora captura das bordas
    %se = strel('disk', 1);
    %img_bw = imerode(img_bw, se);

    % Utilização de dois regionprops ->
        % Um para alternativas não preenchidas e outro para preenchidas
    props_bg = regionprops(img_bw, ...
        "Circularity", "Area", "BoundingBox", "Centroid");
    props_fg = regionprops(~img_bw, ...
        "Circularity", "Area", "BoundingBox", "Centroid");
    
    % Filtros com delimitações baseadas em testes
    filtro_n_marcadas = @(props) ...
        [props.Circularity] > 0.6 & [props.Area] > 65  & [props.Area] < 130;
    filtro_marcadas = @(props) ...
        [props.Circularity] > 0.7 & [props.Area] > 135 & [props.Area] < 285;
    
    % Aplicação de filtros
    n_marcadas = filtro_n_marcadas(props_bg);
    marcadas = filtro_marcadas(props_fg);

    % Alternativas de ambos filtros
    alternativas_n_marcadas = reshape([props_bg(n_marcadas).Centroid], 2, []).';
    alternativas_marcadas   = reshape([props_fg(marcadas).Centroid], 2, []).';

    % BoundingBox de cada bolha
    bordas_n_marcadas = reshape([props_bg(n_marcadas).BoundingBox], 4, []).';
    bordas_marcadas = reshape([props_fg(marcadas).BoundingBox], 4, []).';

    % Visualização das alternativas
    figure, imshow(img_bw); 
    hold on;
    
    % Alternativas não marcadas recebem borda Azul
    for k = 1:size(alternativas_n_marcadas, 1)
        rectangle('Position', bordas_n_marcadas(k, :), 'EdgeColor', 'b');
        plot(alternativas_n_marcadas(k, 1), alternativas_n_marcadas(k, 2), 'bo');
    end
    
    % Alternativas marcadas recebem borda Verde
    for k = 1:size(alternativas_marcadas, 1)
        rectangle('Position', bordas_marcadas(k, :), 'EdgeColor', 'g');
        plot(alternativas_marcadas(k, 1), alternativas_marcadas(k, 2), 'r+');
    end
    hold off;

    % Adicionando 
    %   ones para marcadas  |  zeros para não marcadas 
    alternativas_marcadas_info = [alternativas_marcadas, ...
        ones(size(alternativas_marcadas, 1), 1)];
    alternativas_n_marcadas_info = [alternativas_n_marcadas, ...
        zeros(size(alternativas_n_marcadas, 1), 1)];
  
    % Junção de todas alternativas
    todas_alternativas = [alternativas_marcadas_info; alternativas_n_marcadas_info];

    % Ordenação crescente para valores Y
    todas_alternativas = sortrows(todas_alternativas, 2);

    % Inicializar vetor para marcar ruídos
    eh_ruido = false(size(todas_alternativas, 1), 1);
    
    % Laço para remover ruídos
    for i = 1:size(todas_alternativas, 1)
        alternativa = todas_alternativas(i, :);
    
        distancias = sqrt(sum((todas_alternativas - alternativa).^2, 2));

        % Quantos vizinhos reais a menos de 30 pixels (excluindo ele mesmo)?
        num_vizinhos = sum(distancias < 30) - 1;
    
        % O mínimo de vizinhos por bolha é 2
        if num_vizinhos == 0
            eh_ruido(i) = true;
        end
    end

    % Remove alternativas marcadas como ruído
    todas_alternativas(eh_ruido, :) = [];

    if length(todas_alternativas(:, 1)) ~= 250
        disp("Erro na captura de bolhas");
        return;
    end
     
    % Cópia para desgaste
    restantes = todas_alternativas;

    % Parâmetro de tolerância -> Valor encontrado manualmente
    tol_y = 20;

    % Lista de grupos finais (questões)
    questoes = {};
    
    % Laço de identificação de alternativas de cada questão
    while ~isempty(restantes)

        % Ponto de refêrencia
        ponto_base_y = restantes(1,:);
        
        % Coleta de pertencentes a linha de acordo com tolerância
        mesma_linha = abs(restantes(:,2) - ponto_base_y(2)) < tol_y;
        linha = restantes(mesma_linha, :);
    
        % Ordenação crescente da linha
        linha = sortrows(linha, 1);
        
        % Captura das alternativas de cada coluna
        try
            questoes{end+1} = linha(1:5, :);
            questoes{end+1} = linha(6:10, :);
        catch
            disp("Erro: Questões não detectadas corretamente");
            return;
        end

        % Encontrar valores capturados
        idx_linha = find(mesma_linha);
        restantes(idx_linha, :) = [];
    end
    
    % Inicialização de array respostas
    respostas = zeros(50,1);
    
    % Atribuição de questão em respostas
    for i = 1:length(questoes)
        
        q = questoes{i};

        alternativa_marcada_questao = find(q(:, 3) == 1);
        resp = length(alternativa_marcada_questao);

        if mod(i, 2) == 1
            v = floor((i + 1) / 2);
        else 
            v = 25 + floor(i / 2);
        end
        if resp == 1
            respostas(v) = alternativa_marcada_questao;
        elseif resp > 1
            respostas(v) = 0;
        end
    end
end