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
using System.Threading;

namespace KINS_SYSTEM.Pages.CustomerManagement
{
    /// <summary>
    /// CustomerInfoSync1 的摘要说明
    /// </summary>
    public class CustomerInfoSync1 : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            ///如果是无参数访问，返回数据条数和最新的查询码
            if (context.Request["data"] == null)
            {
                long oldSum = long.Parse(GetOldSum());
                if (oldSum == 0)
                {
                    context.Response.Write(null);
                }
                else
                    context.Response.Write(oldSum + "," + GetOldCustomer());
            }
            else
            {
                Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
                string result = UpdateInfo(data);
                if (int.Parse(data.count) % 10 == 0)
                {
                    Random ran = new Random();
                    int RandKey = ran.Next(150, 240);
                    Thread.Sleep(RandKey * 1000);
                }
                else
                {
                    Random ran = new Random();
                    int RandKey = ran.Next(10, 20);
                    Thread.Sleep(RandKey * 1000);
                }
                context.Response.Write(result);
                return;
            }
        }

        public string GetOldSum()
        {
            string sqlStr = "SELECT count(*) FROM K_CustomerInfo where Ci_isInfoNew=0 ";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            if (int.Parse(da.Rows[0][0].ToString()) <= 0)
            {
                return "null";
            }
            else return da.Rows[0][0].ToString();
        }


        //获取一个信息待更新客户中历史交易额最高客户的查询码
        public string GetOldCustomer()
        {
            string sqlStr = "SELECT top 1 Ci_infoId FROM K_CustomerInfo where Ci_isInfoNew=0 order by Ci_tradeAmount desc";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            if (da.Rows.Count <= 0)
            {
                return "null";
            }
            else return da.Rows[0][0].ToString();
        }

        //更新客户的信息
        private string UpdateInfo(Data data)
        {
            string sqlStr =
                " update K_CustomerInfo set Ci_sex='" + data.sex +
                "',Ci_name='" + data.name +
                "',Ci_email='" + data.email +
                "',Ci_phone='" + data.phone +
                "',Ci_city='" + data.city +
                "',Ci_vipLevel='" + data.level +
                "',Ci_vipState='" + data.state +
                "',Ci_address='" + data.addr +
                "',Ci_marks='" + data.marks +
                "',Ci_rank='" + data.rank +
                "',Ci_birth='" + data.birth +
                "',Ci_tradeAmount='" + data.tradeAmount +
                "',Ci_goodsNum='" + data.goodsNum +
                "',Ci_tradeCloseNum='" + data.tradeClose +
                "',Ci_isInfoNew='" + 1 +
                "' where Ci_infoId='" + data.infoName + "'";
            DbSql ds = new DbSql();
            if (ds.ExecSql(sqlStr))
            {
                return GetOldCustomer();//成功
            }
            return "0";//失败
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public class Data
        {
            public string
                sex = "",
                name = "",
                email = "",
                phone = "",
                city = "",
                level = "",
                state = "",
                addr = "",
                marks = "",
                infoName = "",
                rank = "",
            birth = "",
            tradeAmount = "",
            tradeNum = "",
                goodsNum = "",
                count = "",
                tradeClose = "";
        }
    }
}