
function loadChartWithData(jsonData) {
    Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
    Chart.defaults.global.defaultFontColor = '#292b2c';
    let jsonObject = JSON.stringify(jsonData);
    let jData = JSON.parse(jsonObject);
            
    let labelList = new Array();
    let valueList = new Array();
    
    for(let i = 0; i<jData.length; i++) {
        let d = jData[i];
        labelList.push(d.month + "월");
        valueList.push(d.numberOfPerson);
    }

    let ctx = document.getElementById("myBarChart");
    let myLineChart = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: labelList,
        datasets: [{
        label: "월별 가입 회원수",
        backgroundColor: "rgba(2,117,216,1)",
        borderColor: "rgba(2,117,216,1)",
        data: valueList,
        }],
    },
    options: {
        scales: {
        xAxes: [{
            time: {
            unit: '월'
            },
            gridLines: {
            display: false
            },
            ticks: {
            maxTicksLimit: 100
            }
        }],
        yAxes: [{
            ticks: {
            min: 0,
            max: 10,
            maxTicksLimit: 100
            },
            gridLines: {
            display: true
            }
        }],
        },
        legend: {
        display: false
        }
    }
    });

}