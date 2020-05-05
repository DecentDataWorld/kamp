Analytics = Segment::Analytics.new({
   write_key: '79hast8xqq',
   on_error: Proc.new { |status, msg| print msg }
})
