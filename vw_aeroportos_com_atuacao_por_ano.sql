CREATE OR REPLACE VIEW vw_aeroportos_com_atuacao_por_ano AS
WITH aeroportos_com_atuacao_por_ano AS (SELECT ai_origem.name AS Nome_Aeroporto_Origem,
ai_origem.icao AS ICAO_Aeroporto_Origem,
ac.razao_social AS Razao_Social_Companhia,
COUNT(DISTINCT v.icao_aerodromo_origem) AS Quantidade_Rotas_Partida,
COUNT(DISTINCT v.icao_aerodromo_destino) AS Quantidade_Rotas_Destino,
LEFT(v.partida_prevista,4) ano
FROM vra v 
INNER JOIN aerodromo_info ai_origem ON v.icao_aerodromo_origem  = ai_origem.icao
INNER JOIN air_cia ac ON v.icao_empresa_aerea = ac.icao
GROUP BY ai_origem.name,
ai_origem.icao,
ac.razao_social,
LEFT(v.partida_prevista,4))

SELECT Nome_Aeroporto_Origem,
ICAO_Aeroporto_Origem,
Razao_Social_Companhia,
Quantidade_Rotas_Partida,
Quantidade_Rotas_Destino,
Quantidade_Rotas_Partida + Quantidade_Rotas_Destino AS Total_pouso_Decolagens,
ano
FROM aeroportos_com_atuacao_por_ano;