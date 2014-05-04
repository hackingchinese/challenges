module Charts
  module_function
  def goal_chart(participation)
    list = []
    carry = 0
    participation.activity_logs.order('created_at asc').each do |log|
      carry += log.units_accomplished
      list << [ log.created_at.to_date.to_time.to_i * 1000, carry]
    end
    {
      chart: {},
      title: { text: 'Performance Chart' },
      xAxis: {
        type: 'datetime',
        plotBands: [{
          from: Time.zone.now.to_i * 1000,
          to: participation.challenge.to_date.to_time.to_i * 1000,
          color: 'rgba(68, 170, 213, .2)',
          label: {
            text: 'Future'
          }
        }]
      },
      plotOptions: {
        line: {
          dataLabels: {
            enabled: true
          },
          enableMouseTracking: false
        }
      },
      series: [
        {
          name: 'Average goal performance target',
          data: [
            [ participation.challenge.from_date.to_time.to_i * 1000, 0 ],
            [ participation.challenge.to_date.to_time.to_i * 1000, participation.challenge_goal ]
          ]
        },
        {
          name: 'Accumulated actual performance',
          type: 'area',
          data: list
        }
      ]
    }
  end
end
