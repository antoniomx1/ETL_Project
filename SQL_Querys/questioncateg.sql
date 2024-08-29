select
    substring_index(database(),"_",-1) as `aula`,
    id as `categoria` , name as `nombre`
    from mdl_question_categories

