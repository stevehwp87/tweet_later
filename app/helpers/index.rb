helpers do
  def user_logged
    user = nil
    if session[:user]
      db = Daybreak::DB.new DATABASE
      user = db[session[:user]]
      db.close
    end
    user
  end


  def job_is_complete(jid)
    waiting = Sidekiq::Queue.new
    working = Sidekiq::Workers.new
    pending = Sidekiq::ScheduledSet.new
    return false if pending.find { |job| job.jid == jid }
    return false if waiting.find { |job| job.jid == jid }
    return false if working.find { |process_id, thread_id, work| work["payload"]["jid"] == jid }
    true
  end

end