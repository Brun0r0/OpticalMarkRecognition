function imagem_tratada = img2bw(imagem)

    % Convertendo imagem para gray scale
    img_gray = rgb2gray(uint8(imagem));
    
    % Binarização com Otsu
    level = graythresh(img_gray);
    img_bw = imbinarize(img_gray, level);
    
    % Remoção de objetos com área indicada no segundo parâmetro
    img_sruido = bwareaopen(img_bw, 10^5);

    % Operação de dilatação
    se = strel('disk', 10);
    imagem_tratada = imdilate(img_sruido, se);
end