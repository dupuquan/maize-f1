import pandas as pd

# 读取output和genome_tester文件
output_df = pd.read_excel('output.xlsx')
genome_tester_df = pd.read_excel('genome_tester.xlsx')

# 获取所有染色体名称
chromosome_names = [col for col in genome_tester_df.columns if col != 'id']

# 通过id和染色体名称匹配数据，将genome_tester中的"-"替换为output中的对应碱基
for chromosome in chromosome_names:
    # 提取左侧碱基列名
    left_base_column = chromosome
    
    # 检查左侧碱基列是否在output文件中存在
    if left_base_column in output_df.columns:
        # 匹配id并进行替换
        for idx in genome_tester_df.index:
            if genome_tester_df.at[idx, chromosome] == '-':
                corresponding_id = genome_tester_df.at[idx, 'id']
                corresponding_base = output_df.loc[output_df['id'] == corresponding_id, left_base_column].values
                if len(corresponding_base) > 0:
                    genome_tester_df.at[idx, chromosome] = corresponding_base[0]

# 将处理后的数据保存为新的Excel文件
genome_tester_df.to_excel('cj.xlsx', index=False)
