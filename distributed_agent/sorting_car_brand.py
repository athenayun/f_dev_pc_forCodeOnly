def sorting_car_brand(df) :
    brand_list = []
    categories = [31, 32, 41, 42, 5]
    car_dict = {}
    car_dfs = []
    for car in df['VEHICLE_ID'].unique() :
        
        #brand = pd.DataFrame(df[df.VEHICLE_ID == car].head(1))
        brand = df[df.VEHICLE_ID == car].head(1)
        
        brand_list.append(brand)
    brand_df = pd.concat(brand_list, axis=0)
    
    for category in categories :
        series = brand_df[(brand_df.MVDIS_CATEGORY == category)].groupby("BRAND").size().sort_values(0, ascending=False)[:20]
        tmp_df = pd.DataFrame(series).reset_index()
        car_dict['group_{0}'.format(category)] = tmp_df
        car_dfs.append(car_dict['group_{0}'.format(category)])
    result_df = pd.concat(car_dfs, axis=1)
    
    iterables = [['31', '32', '41', '42', '5'], ['BRAND', 'car_num']]
    col = pd.MultiIndex.from_product(iterables)
    result_df.columns = col
    return result_df