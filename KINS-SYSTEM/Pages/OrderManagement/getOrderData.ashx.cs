using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace KINS_SYSTEM.Pages.OrderManagement
{
    /// <summary>
    /// getOrderData 的摘要说明
    /// </summary>
    public class getOrderData : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            context.Response.Write(getData(data));
        }
        private string getData(Data data) {
            string sqlStr = " select top 200 * from K_TaobaoOrder where 1=1";
            sqlStr += getSqlStr(data);
            sqlStr += " and 订单编号 not in ( select top " + (data.starCom - 1) + " 订单编号 from  K_TaobaoOrder where 1=1 " + getSqlStr(data) + " order  by 订单付款时间 desc)";
            sqlStr += "  order by 订单付款时间 desc";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            da.Rows.Add(da);                //将这一行记录加这个表中
            sqlStr = "select count (*) from K_TaobaoOrder where 1=1 " + getSqlStr(data);
            string temp = ds.FillDt(sqlStr).Rows[0][0].ToString();
            DataRow row = da.NewRow();
            row["订单编号"] = temp;
            da.Rows.Add(row);

            return (JsonConvert.SerializeObject(da, new DataTableConverter()));
        }
        private string getSqlStr(Data data) {
            string sqlStr = "";
            if (data.buyerUsername != "")
                sqlStr += " and 买家会员名 like '%" + data.buyerUsername + "%'";
            if (data.originalId != "")
                sqlStr += " and 订单编号 like '%" + data.originalId + "%'";
            if (data.orderItemTitle != "")
                sqlStr += " and 订单编号 like '%" + data.orderItemTitle + "%'";
            if (data.waybillNo != "")
                sqlStr += " and 宝贝标题 like '%" + data.waybillNo + "%'";
            if (data.phone != "")
                sqlStr += " and 联系手机 like '%" + data.phone + "%'";
            if (data.consigneeName != "")
                sqlStr += " and 收货人姓名 like '%" + data.consigneeName + "%'";
            return sqlStr;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public class Data {
            public string buyerUsername = "", originalId = "", orderItemTitle = "", waybillNo = "", phone = "", consigneeName="";
            public int starCom;
        }
    }
}