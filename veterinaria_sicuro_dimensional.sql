---Populando a Dimensão Cliente (dim_cliente)
SELECT * FROM cliente;

INSERT INTO dw_veterinaria_sicuro.dim_cliente (nk_id_cliente, nm_cliente, bairro, cidade, estado)
SELECT
    id_cliente,
    nome_cliente,
    bairro,
    cidade,
    estado
FROM
    public.cliente; 
	
SELECT* FROM dw_veterinaria_sicuro.dim_cliente;
	
---Populando a Dimensão Animal (dim_animal)
	
INSERT INTO dw_veterinaria_sicuro.dim_animal (nk_id_animal, nm_animal, dt_nascimento, sexo_animal, raca, especie)
SELECT
    id_animal,
    nome,
    data_nascimento,
    sexo,
    raca,
    especie
FROM
    public.animal;
	
SELECT* FROM dw_veterinaria_sicuro.dim_animal;


---Populando a Dimensão Data (dim_data)
	
INSERT INTO dw_veterinaria_sicuro.dim_data (nk_data, dia, mes, ano)
SELECT DISTINCT
    data,
    EXTRACT(DAY FROM data) AS dia,
    EXTRACT(MONTH FROM data) AS mes,
    EXTRACT(YEAR FROM data) AS ano
FROM
   public.financeiro;
	
SELECT* FROM dw_veterinaria_sicuro.dim_data;

---Populando a Dimensão Serviço (dim_servico)

INSERT INTO dw_veterinaria_sicuro.dim_servico (nk_item_servico, nm_servico, valor_servico)
SELECT
    id_item_servico,
    nome_servico,
    valor_servico
FROM
    public.servicos;
	
	SELECT* FROM dw_veterinaria_sicuro.dim_servico;
	
---Populando a Fato vendas (ft_venda)

INSERT INTO dw_veterinaria_sicuro.ft_venda (
    sk_data, sk_animal, sk_cliente, sk_servico,
    quantidade, valor
)
SELECT
    d.sk_data, a.sk_animal, c.sk_cliente, s.sk_servico, fi.quantidade, (fi.valor * fi.quantidade)
FROM veterinaria_sicuro.public.financeiro f
JOIN veterinaria_sicuro.public.financeiro_itens fi ON f.id_financeiro = fi.id_financeiro
JOIN dw_veterinaria_sicuro.dim_data d ON f.data = d.nk_data
JOIN dw_veterinaria_sicuro.dim_cliente c ON f.id_cliente = c.nk_id_cliente
JOIN dw_veterinaria_sicuro.dim_animal a ON f.id_animal = a.nk_id_animal
JOIN dw_veterinaria_sicuro.dim_servico s ON fi.id_item_servico = s.nk_item_servico;

SELECT* FROM dw_veterinaria_sicuro.ft_venda;

