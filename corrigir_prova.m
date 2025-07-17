function notaFinal = corrigir_prova(gabarito, respostas, name)
    
    nota = 0;
    notas = [];
    pesoTotal = sum(gabarito(:, 2));

    for i = 1:length(gabarito)
        if(respostas(i) == gabarito(i, 1))
            notaQuestao = gabarito(i, 2);
        else 
            notaQuestao = 0;
        end
        
        nota = nota + notaQuestao;
        notas(end+1) = notaQuestao;
    end

    notaFinal = (nota/pesoTotal) * 100;

    % Criação da tabela principal
    planilhaNotaIndividual = table(respostas(:), gabarito(:,1), notas(:), ...
        'VariableNames', {'Resposta', 'Gabarito', 'Nota'});

    % Linhas extras
    linhaVazia = table("━━━━", "━━━━", "━━━━", ...
        'VariableNames', {'Resposta', 'Gabarito', 'Nota'});

    linhaFinal = table("Nota Final", "━━━━━>", notaFinal, ...
        'VariableNames', {'Resposta', 'Gabarito', 'Nota'});

    % Concatenando tudo
    planilhaNotaIndividual = [planilhaNotaIndividual; linhaVazia; linhaFinal];

    writetable(planilhaNotaIndividual, "Notes/Individual/" + name + ".xls");
end
