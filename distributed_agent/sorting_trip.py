def sorting_trip(df) :
    SA_name = ["Taian", "Zhongli", "Xihu", "Xilou", "Nantou", "QingShui", "Huko", "Guanxi"]
    SA_Cname = ['泰安', '中壢', '西湖', '西螺', '南投', '清水', '湖口', '關西']
    categories = [31, 32, 41, 42, 5]
    for idx, sa in enumerate(SA_Cname) :  # the first SA
        writer = pd.ExcelWriter('D://code//data//data_SA_north//analysis_result//{0}_{1}_all_trip.xlsx'.format(sa, category))
        categories_df = {}
        
        for category in categories :
            var_dict = {}
            cnt_row = []
            for var in SA_Cname :
                var_dict['v_{0}'.format(var)] = 0
            
            unique_bms = df[(df.SERVICE_AREA == sa)&(df.STOP == 'P')&(df.MVDIS_CATEGORY == category)]['BMS_TX_BATCH'].unique()
            
            first_row = []
            second_row = []
            third_row = []
            col_name = []
            
            for bms in unique_bms :
                series = df[(df.BMS_TX_BATCH == bms)&(df.STOP == 'P')].groupby("SERVICE_AREA").size()
                cnt_df = pd.DataFrame(series).reset_index()
                length = cnt_df.shape[0]
                for p_name in [x for index, x in enumerate(SA_Cname) if index != idx] : # this list won't have the first SA itself 
                    for idx_cnt, i in cnt_df.iterrows():
                        if i.SERVICE_AREA == p_name :
                            var_dict["v_{0}".format(p_name)] = var_dict["v_{0}".format(p_name)] + i[0]
            # trip grouping start here
            #bms_df = df[(df.BMS_TX_BATCH.isin(unique_bms))]
            for sa2 in [x for index, x in enumerate(SA_Cname) if index != idx] : # sa2 should be the same with p_name
                col_name.append(sa2)
                select_vID = df[(df.BMS_TX_BATCH.isin(unique_bms))&(df.SERVICE_AREA == sa2)&(df.STOP == 'P')]['VEHICLE_ID'].unique()
                trip_series = df[df.VEHICLE_ID.isin(select_vID)].groupby(['in_location', 'out_location']).size().sort_values(0, ascending=False)[:3]
                trip_df = pd.DataFrame(series_test).reset_index()
                
                for idx_trip, place in trip_df.iterrows():
                    place_string = "{0}-{1}".format(place['in_location'], place['out_location'])
                    trip_dict['{0}_place'.format(idx_trip)] = place_string
                    if idx_trip == 0 :
                        first_row.append(trip_dict['{0}_place'.format(idx_trip)])
                    elif idx_trip == 1 :
                        second_row.append(trip_dict['{0}_place'.format(idx_trip)])
                    elif idx_trip == 2 :
                        third_row.append(trip_dict['{0}_place'.format(idx_trip)])
                # collect the variables of car counting
                cnt_row.append(var_dict['v_{0}'.format(sa2)])
            result_df =  pd.DataFrame([cnt_row, first_row, second_row, third_row], columns = col_name)    
            categories_df['{0}_{1}'.format(sa, category)] = result_df
            
            categories_df['{0}_{1}'.format(sa, category)].to_excel(writer,'{0}_{1}_trip'.format(sa, category)) 
        # saving excel
        #writer = pd.ExcelWriter('D://code//data//data_SA_north//analysis_result//{0}_{1}_all_trip.xlsx'.format(sa, category))
        writer.save()