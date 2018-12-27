using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;
using System.Data;

namespace KINS_SYSTEM.Pages.AttendanceManagement
{
    public partial class CheckIn : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    Response.Redirect("~/Pages/Login.aspx");
                }
                if (Session["permissions"].ToString().IndexOf("#A02") < 0)
                {
                    Response.Redirect("~/Pages/NoPermission.aspx?permissionId=#A02");
                }
            }
            Check();
        }

        //判断十分钟内是否重复打卡
        private Boolean  noMoreCheckIn(DataTable da)
        {
            for (int i = 3; i < 9; i++) {
                if (da.Rows[0][i].ToString() == "" || da.Rows[0][i].ToString() == null)
                    continue;
                TimeSpan ts = DateTime.Now - Convert.ToDateTime(da.Rows[0][i].ToString());
                if (ts.TotalMinutes < 10) {
                    return false;
                }
            }
            return true;
        }

        private void Check()
        {
            DateTime now = DateTime.Now;
            string today = DateTime.Now.Year + "-" + DateTime.Now.Month + "-" + DateTime.Now.Day;
            //先将本日本人的信息查询出来，如果不存在则新插入并返回当日考勤数据信息
            string sqlStr = "select * from K_onoffDutyData where O_employeeId='" + Session["yhm"] + "' and O_checkDate='" + today + "'";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            if (da.Rows.Count == 0)
            {
                sqlStr = "insert into K_onoffDutyData(O_id,O_employeeId,O_checkDate) values('" + Guid.NewGuid() + "','" + Session["yhm"] + "','" + today + "')" + ";" + sqlStr;
                da = ds.FillDt(sqlStr);
            }

            DateTime tempTime = new DateTime(now.Year, now.Month, now.Day, 10, 0, 0);

            //判断十分钟内是否重复打卡
            if (!noMoreCheckIn(da)) {
                tips("十分钟之内不允许重复打卡");
            }

                //上午10点前第一次打卡上班
                if (now < tempTime)
            {
                if (da.Rows[0]["O_onDuty1"].ToString() == "")
                {
                    sqlStr = "update K_onoffDutyData set O_onDuty1 = '" + now + "' where  O_id= '" + da.Rows[0]["O_id"] + "'";
                    if (!ds.ExecSql(sqlStr))
                    {
                        tips("打卡错误，请重试或联系系统管理员");
                        return;
                    }
                    tips("上班打卡成功，打卡时间:" + now.ToString());
                }
                else
                {
                    tips("您已打卡，10点前早退则上午工时无效");
                }
                return;
            }

            //上午10点前第一次打卡上班
            tempTime = tempTime.AddMinutes(150);
            if (now < tempTime)
            {
                if (da.Rows[0]["O_offDuty1"].ToString() == "")
                {
                    sqlStr = "update K_onoffDutyData set O_offDuty1 = '" + now + "' where  O_id= '" + da.Rows[0]["O_id"] + "'";
                    if (!ds.ExecSql(sqlStr))
                    {
                        tips("打卡错误，请重试或联系系统管理员");
                        return;
                    }
                }
                else
                {
                    tips("您已打卡，无法重复打卡；下午上班打卡12：30开始");
                }
                if (da.Rows[0]["O_onDuty1"].ToString() == "")
                {
                    tips("打卡成功，打卡结果您已严重迟到");
                }
                else
                {
                    tips("下班打卡成功，打卡时间:" + now.ToString());
                }
                return;
            }

            //下午上班打卡
            tempTime = tempTime.AddMinutes(150);
            if (now < tempTime)
            {
                if (da.Rows[0]["O_onDuty2"].ToString() == "")
                {
                    sqlStr = "update K_onoffDutyData set O_onDuty2 = '" + now + "' where  O_id= '" + da.Rows[0]["O_id"] + "'";
                    if (!ds.ExecSql(sqlStr))
                    {
                        tips("打卡错误，请重试或联系系统管理员");
                        return;
                    }
                    tips("上班打卡成功，打卡时间:" + now.ToString());
                }
                else
                {
                    tips("您已打卡，无法重复打卡；15:00前早退则下午工时无效");
                }
                return;
            }

            //下午下班打卡
            tempTime = tempTime.AddMinutes(240);
            if (now < tempTime)
            {
                if (da.Rows[0]["O_offDuty2"].ToString() == "")
                {
                    sqlStr = "update K_onoffDutyData set O_offDuty2 = '" + now + "' where  O_id= '" + da.Rows[0]["O_id"] + "'";
                    if (!ds.ExecSql(sqlStr))
                    {
                        tips("打卡错误，请重试或联系系统管理员");
                        return;
                    }
                }
                else
                {
                    tips("您已打卡，无法重复打卡；晚上加班打卡17:00开始");
                }
                if (da.Rows[0]["O_onDuty2"].ToString() == "")
                {
                    tips("打卡成功，打卡结果您已严重迟到");
                }
                else
                {
                    tips("下班打卡成功，打卡时间:" + now.ToString());
                }
                return;
            }

            //晚班上班打卡
            if (da.Rows[0]["O_onDuty3"].ToString() == "")
            {
                sqlStr = "update K_onoffDutyData set O_onDuty3 = '" + now + "' where  O_id= '" + da.Rows[0]["O_id"] + "'";
                if (!ds.ExecSql(sqlStr))
                {
                    tips("打卡错误，请重试或联系系统管理员");
                    return;
                }
                tips("晚班上班打卡成功，打卡时间:" + now.ToString());
                return;
            }

            //晚班下班打卡
            if (da.Rows[0]["O_offDuty3"].ToString() == "")
            {
                sqlStr = "update K_onoffDutyData set O_offDuty3 = '" + now + "' where  O_id= '" + da.Rows[0]["O_id"] + "'";
                if (!ds.ExecSql(sqlStr))
                {
                    tips("打卡错误，请重试或联系系统管理员");
                    return;
                }
                tips("今天工作已经完成，好好休息，明天继续努力，打卡时间:" + now.ToString());
                return;
            }
            else
            {
                tips("今天工作已经完成，好好休息，明天继续努力");
            }
        }

        private void tips(string tip)
        {
            Response.Write("<script language='javascript' type='text/javascript'>  alert('" + tip + "');window.parent.location.href = '../Index.aspx?frame_url=AttendanceManagement/AttendanceManagement.aspx';</script>");
        }
    }
}