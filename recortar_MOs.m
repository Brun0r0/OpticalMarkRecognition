function img_cortada = recortar_MOs(imagem)
    
    % Realiza um conjunto de operações e retorna bw
    img = img2bw(imagem);

    % Capturando propriedades da imagem
    %   Circularidade, Centróide, Caixa Delimitadora e Área
    props = regionprops(~img,"Circularity", 'Centroid', 'BoundingBox', 'Area');
    
    centros = zeros(3,2);
    i = 1;

    % Iteração para captura das circunferências
    for k = 1:length(props)
        A = props(k).Area;
        C = props(k).Circularity;

        if C > 0.85 && A > 500
            centros(i,:) = props(k).Centroid;
            i = i+1;
        end
    end
    
    % Conexões possíveis entre pontos
    pontos = {[1 2] [2 3] [1 3]};

    maiorDist = 0;

    % Cálculo da distância entre pontos
    for i = 1:3
        par = pontos{i};
        valor = norm(centros(par(1), :) - centros(par(2), :));
    
        if(maiorDist < valor)
            maiorDist = valor;
            pontoMaiorDist = par;
        end
    end
    
    % Ligação entre os pontos para secção
    x1 = centros(pontoMaiorDist(1),1);
    x2 = centros(pontoMaiorDist(2),1);
    y1 = centros(pontoMaiorDist(1),2);
    y2 = centros(pontoMaiorDist(2),2);
    %   Utilizando dessa forma fica mais fácil de visualizar   
    
    % Coordenadas Iniciais
    yInicio = round(min(y1, y2));
    xInicio = round(min(x1,x2));

    % Coordenadas finais
    yFim = round(max(y1,y2));
    xFim = round(max(x1,x2));
    
    % Figura principal seccionada
    img_cortada = imagem(yInicio:yFim, xInicio:xFim);
end