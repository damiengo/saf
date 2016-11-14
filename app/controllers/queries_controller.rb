class QueriesController < ApplicationController

  def index
    @sqls = Dir["stats/*/*.sql"]
  end

  def show_script
    @script_name    = params['script']
    @script_content = File.read(@script_name, encoding: 'bom|utf-8')
    @script_results = ActiveRecord::Base.connection.execute(@script_content);
    render json: {:script_name    => @script_name,
                  :script_content => @script_content,
                  :script_results => @script_results},
           status: 200
  end
end
