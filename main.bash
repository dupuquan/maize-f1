#!/bin/bash
eval "$(micromamba shell hook --shell bash)"
micromamba activate F1
cd /public/home/pqdu/maize/mature_data/new
x=$(ls /public/home/pqdu/maize/mature_data/new/output)
let i=1
for a in $x
do
	
	mkdir "/public/home/pqdu/maize/mature_data/new/new_folder_$i"
	echo "
import os
import pandas as pd
import openpyxl
import numpy as np
# 循环创建文件夹

chr_signal_change=['9_12652123','9_12641123','9_12633072','9_12631049','9_23989836','9_12612853','9_12617994','9_12631091','9_12676638','9_12670767']#该位点是染色体的分界线
def extract_column_names(file_path, column_index):#return two spream_name 用于返回列名 column_index=1,就返回第二列，column_index=2就返回第一列
    '''
    从Excel文件中提取指定列的列名。

    Args:
        file_path (str): Excel文件的路径。
        column_index1 (int): 第一个列的索引（从0开始）。
        column_index2 (int): 第二个列的索引（从0开始）。

    Returns:
        tuple: 包含两个列名的元组。
    '''
    try:
        df = file_path
        column_name = df.columns[column_index]
        return column_name
    except Exception as e:
        return f'出现错误：{str(e)}'
    
def get_all_filepaths(folder_path):#用于获取output文件夹中的所有文件路径
    '''
    获取指定文件夹下的所有文件路径。

    Args:
        folder_path (str): 文件夹路径。

    Returns:
        list: 包含所有文件路径的列表。
    '''
    all_filepaths = []
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_path = os.path.join(root, file)
            all_filepaths.append(file_path)
    return all_filepaths
subdirectory = '/public/home/pqdu/maize/mature_data/new/output'
current_directory = os.path.abspath(os.getcwd())
os.chdir(subdirectory)# 进入子目录

# 读取原始dataframe
original_df = pd.read_excel('$a')  # 替换为你的dataframe文件路径 ################################################3
os.chdir(current_directory)
# 初始化一个空字典来存储染色体  
chromosomes = {}  
chr_num = 1  # 初始化染色体编号  
start_index = None  # 开始索引，初始化为None  
  
# 遍历DataFrame的索引，分割染色体  
for index, row in original_df.iterrows():  
    if row['id'] in chr_signal_change:  
        # 如果当前行是分割点，并且之前已经有数据被收集（start_index不是None）  
        if start_index is not None:  
            # 将从上一个分割点到当前分割点之间的数据添加到字典中  
            chromosomes[f'chr{chr_num}'] = original_df.iloc[start_index:index].copy()  
            chr_num += 1  # 更新染色体编号  
        start_index = index + 1  # 更新开始索引为当前分割点的下一个位置  
  
# 添加最后一个染色体（如果有的话）  
if start_index is not None and start_index < len(original_df):  
    chromosomes[f'chr{chr_num}'] = original_df.iloc[start_index:].copy()  
w=0
# 遍历 chr_signal_change 中的每个值
for signal in chr_signal_change:
    # 从 original_df 中找到对应的行
    corresponding_row = original_df.loc[original_df['id'] == signal]
    row_data = corresponding_row.iloc[0].to_dict()
    new_row = pd.DataFrame(row_data, index=[0])
    
    if w==0:
        chromosomes['chr1'] = pd.concat([new_row, chromosomes['chr1']], axis=0).reset_index(drop=True)
    elif w==1:
        chromosomes['chr2'] = pd.concat([new_row, chromosomes['chr2']], axis=0).reset_index(drop=True)
    elif w==2:
        chromosomes['chr3'] = pd.concat([new_row, chromosomes['chr3']], axis=0).reset_index(drop=True)
    elif w==3:
        chromosomes['chr4'] = pd.concat([new_row, chromosomes['chr4']], axis=0).reset_index(drop=True)
    elif w==4:
        chromosomes['chr5'] = pd.concat([new_row, chromosomes['chr5']], axis=0).reset_index(drop=True)
    elif w==5:
        chromosomes['chr6'] = pd.concat([new_row, chromosomes['chr6']], axis=0).reset_index(drop=True)
    elif w==6:
        chromosomes['chr7'] = pd.concat([new_row, chromosomes['chr7']], axis=0).reset_index(drop=True)
    elif w==7:
        chromosomes['chr8'] = pd.concat([new_row, chromosomes['chr8']], axis=0).reset_index(drop=True)
    elif w==8:
        chromosomes['chr9'] = pd.concat([new_row, chromosomes['chr9']], axis=0).reset_index(drop=True)
    elif w==9:
            chromosomes['chr10'] = pd.concat([new_row, chromosomes['chr10']], axis=0).reset_index(drop=True)

    w=w+1
# 2. 读取已处理的文件列表
processed_files = set()

# 3. 遍历txt文件夹中的每个文件
txt_folder = '/public/home/pqdu/maize/mature_data/new/folder_"$i"'#######################################################3
new_folder = '/public/home/pqdu/maize/mature_data/new/new_folder_"$i"'######################################################

# 按顺序读取文件
txt_files = sorted(os.listdir(txt_folder))

for txt_file in txt_files:
    if txt_file.endswith('.txt') and txt_file not in processed_files:
        txt_path = os.path.join(txt_folder, txt_file)
        
        # 读取txt文件中的位点
        with open(txt_path, 'r') as f:
            txt_lines = f.readlines()
        txt_lines = [line.strip() for line in txt_lines]

        # 4. 处理Chromosome数据
        for i in range(0, len(txt_lines), 2):
            chr_key = f'chr{int(i/2) + 1}'  # 计算对应的Chromosome键名
            id_1, id_2 = txt_lines[i], txt_lines[i+1]  # 获取txt文件中的位点对
            
            # 判断Chromosome中是否有对应的键
            if chr_key in chromosomes:
                df = chromosomes[chr_key]
                
                # Check if id_1 is in the id column of the DataFrame
                if id_1 in df['id'].values:
    # Find the index of id_1
                    idx_1 = df.loc[df['id'] == id_1].index[0]
    
                    # Swap the data for EMF1 and EMF2 columns starting from idx_1
                    temp_1 = df.loc[idx_1:, extract_column_names(original_df, 1)].copy()
                    temp_2 = df.loc[idx_1:, extract_column_names(original_df, 2)].copy()
                    df.loc[idx_1:, extract_column_names(original_df, 1)] = temp_2
                    df.loc[idx_1:, extract_column_names(original_df, 2)] = temp_1

                # Check if id_2 is in the id column of the DataFrame
                if id_2 in df['id'].values:
                    # Find the index of id_2
                    idx_2 = df.loc[df['id'] == id_2].index[0]
                    
                    # Swap the data for EMF1 and EMF2 columns starting from idx_2
                    temp_3 = df.loc[idx_2:, extract_column_names(original_df, 1)].copy()
                    temp_4 = df.loc[idx_2:, extract_column_names(original_df, 2)].copy()
                    df.loc[idx_2:, extract_column_names(original_df, 1)] = temp_4
                    df.loc[idx_2:, extract_column_names(original_df, 2)] = temp_3
                    
                    
                    # 更新Chromosome中的数据
                    chromosomes[chr_key] = df
        
        
        # 5. 将处理后的Chromosome转换成DataFrame格式并保存到新的文件夹中
        new_file_path = os.path.join(new_folder, txt_file.replace('.txt', '_processed.csv'))
        pd.concat(chromosomes.values()).reset_index(drop=True).to_csv(new_file_path, index=False)
        
        # 记录已处理的文件
        processed_files.add(txt_file)
" > $a.py
	bsub -J $a.py -n 4 -o %J.out -e %J.err -q normal "python -t $a.py" # 提交program程序运行
	let i=i+1
done
