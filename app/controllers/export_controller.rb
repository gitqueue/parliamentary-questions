class ExportController < ApplicationController
  before_action :authenticate_user!, PQUserFilter


  def index
  end


  def csv
    pqs = PQ.where('created_at >= ? AND updated_at <= ?', params[:date_from], params[:date_to]).order(:uin)
    send_data to_csv(pqs)
  end

  private

  def to_csv(pqs)
    CSV.generate do |csv|
      csv << [
          'MP',
          'Record Number',
          'Action Officer',
          'Date response answered by Parly (dept)',
          'Draft due to Parly Branch',
          'Date First Appeared in Parliament',
          'Date Due in Parliament',
          'Date resubmitted to Minister (if appliable)',
          'Date returned by AO (if applicable)',
          'Date Draft Returned to PB',
          'Date sent back to AO (if applicable)',
          'Date delivered to Minister',
          'Returned signed from Minister',
          'Directorate',
          'Division',
          'Final Response',
          'Full_PQ_subject',
          'Delay Reason',
          'Minister',
          'Ministerial Query? (if applicable)',
          'PIN',
          '"Date/time of POD clearance"',
          'PODquery',
          'Requested by finance',
          'Requested by HR',
          'Requested by Press',
          'Type of Question',
          'AO Email'
      ]


      pqs.each do |pq|

        ao = pq.action_officer_accepted
        ao_name = ao.nil? ? '' : ao.name
        ao_email = ao.nil? ? '' : ao.email
        division = ao.nil? ? '' : ao.deputy_director.division.name
        directorate = ao.nil? ? '' : ao.deputy_director.division.directorate.name
        minister_name = pq.minister.nil? ? '' : pq.minister.name

        csv << [
            pq.member_name,           # 'MP',
            '',                       # 'Record Number',
            ao_name,                  # 'Action Officer',
            pq.answer_submitted,      # 'Date response answered by Parly (dept)',
            pq.internal_deadline,     # 'Draft due to Parly Branch',
            pq.tabled_date,           # 'Date First Appeared in Parliament',
            pq.date_for_answer,       # 'Date Due in Parliament',
            pq.resubmitted_to_answering_minister,             # 'Date resubmitted to Minister (if appliable)',
            pq.answering_minister_returned_by_action_officer, # 'Date returned by AO (if applicable)',
            pq.draft_answer_received,                         # 'Date Draft Returned to PB',
            pq.answering_minister_to_action_officer,          # 'Date sent back to AO (if applicable)',
            pq.sent_to_answering_minister,                    # 'Date delivered to Minister',
            pq.cleared_by_answering_minister,                 # 'Returned signed from Minister',
            directorate,                 # 'Directorate',
            division,                    # 'Division',
            pq.answer,                   # 'Final Response',
            pq.question,                 # 'Full_PQ_subject',
            '',                          # 'Delay Reason',
            minister_name,               # 'Minister',
            pq.answering_minister_query, # 'Ministerial Query? (if applicable)',
            pq.uin,                      # 'PIN',
            pq.pod_clearance,            # '"Date/time of POD clearance"',
            pq.pod_query_flag,           # 'PODquery',
            pq.finance_interest,         # 'Requested by finance',
            '',                          # 'Requested by HR',
            '',                          # 'Requested by Press',
            pq.question_type,            # 'Type of Question',
            ao_email,                    # 'AO Email'
        ]
      end
    end
  end

end