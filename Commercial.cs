using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TransSeas.Models
{
    public class CommercialMT
    {
        public int com_id { get; set; }
        public string com_inv_no { get; set; }
        public string com_date { get; set; }
        public int loc_id { get; set; }
        public string loc_desc { get; set; }
        public int sr_id { get; set; }
        public string sr_name { get; set; }
        public int cust_id { get; set; }
        public string cust_name { get; set; }
        public string com_order_date { get; set; }
        public string com_order_no { get; set; }
        public string com_ts_reff { get; set; }
        public int trans_id { get; set; }
        public string trans_desc { get; set; }
        public int proj_id { get; set; }
        public string proj_name { get; set; }
        public int cur_id { get; set; }
        public string cur_desc { get; set; }
        public int cur_type_id { get; set; }
        public string cur_type_desc { get; set; }
        public int ofc_id { get; set; }
        public string ofc_name { get; set; }
    }
    public class CommercialDT
    {
        public int com_det_id { get; set; }
        public int com_id { get; set; }
        public int com_quantity { get; set; }
        public string com_desc { get; set; }
        public float com_unit_price { get; set; }
        public float com_line_price { get; set; }
    }
    public class CommercialDetail
    {

        public int item_no { get; set; }
        public int com_quantity { get; set; }
        public string com_desc { get; set; }
        public string com_unit_price { get; set; }
        public string com_line_total { get; set; }
        public string cur_desc { get; set; }
    }

}