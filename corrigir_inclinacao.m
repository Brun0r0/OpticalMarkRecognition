function img_rotated =  corrigir_inclinacao(imagem)

    % Realiza um conjunto de operações e retorna bw
    img = img2bw(imagem); 

    % Capturando propriedades da imagem
    %   Circularidade, Centróide, Caixa Delimitadora e Área
    props = regionprops(~img,"Circularity", 'Centroid', 'BoundingBox', 'Area');
   
    centros = zeros(3,2);
    i = 1;

    %figure, imshow(img), hold on;

    % Iteração para captura das circunferências
    for k = 1:length(props)
        A = props(k).Area;
        C = props(k).Circularity;

        if C > 0.85 && A > 500
            %rectangle('Position', props(k).BoundingBox, 'EdgeColor', 'g');
            %plot(props(k).Centroid(1), props(k).Centroid(2), 'r+');
            centros(i,:) = props(k).Centroid;
            i = i+1;
        end
    end
    %hold off

    % Conexões possíveis entre pontos
    pontos = {[1 2] [2 3] [1 3]};

    menorDist = inf; maiorDist = 0;

    % Cálculo da distância entre pontos
    for i = 1:3
        par = pontos{i};
        valor = norm(centros(par(1), :) - centros(par(2), :));
    
        if(menorDist > valor)
            menorDist = valor;
            pontoMenorDist = par;
        end
        if(maiorDist < valor)
            maiorDist = valor;
            pontoMaiorDist = par;
        end
    end

    % Identificação de cada ponto
    pontoBaixoDir = intersect(pontoMaiorDist, pontoMenorDist);
    pontoCimaEsq = setdiff(pontoMaiorDist, pontoBaixoDir);
    pontoBaixoEsq = setdiff(pontoMenorDist, pontoBaixoDir);

    % Coordenadas de cada ponto
    coordCimaEsq = centros(pontoCimaEsq,:);
    coordBaixoEsq = centros(pontoBaixoEsq,:);
    coordBaixoDir = centros(pontoBaixoDir,:);

    % Correção de sinal para imagem invertida
    if coordCimaEsq(2) > coordBaixoDir(2)
        imagem = imrotate(imagem, 180);
        sinal = 1;
    else 
        sinal = -1;
    end

    % Cálculo do cateto oposto dessa triangulação
    cateto_oposto = coordBaixoEsq(2) - coordBaixoDir(2);

    % Ângulo utilizado para correção
    correcao_angulo = sinal * asind(cateto_oposto/menorDist);
   
    % Imagem com rotação corrigida
    img_rotated = imrotate(imagem, correcao_angulo, 'bilinear', 'crop');
end