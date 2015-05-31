<Block>
	<Method name='put'>
		<Args>
			<Arguments>
				<Argument name='x'/>
			</Arguments>
		</Args>
		<Call name='print'>
			<Args>
				<Variable name='x'/>
			</Args>
		</Call>
	</Method>
	<Method name='grep'>
		<Args>
			<Arguments>
				<Argument name='xs'/>
				<Argument name='x'/>
			</Arguments>
		</Args>
		<Call name='select'>
			<Variable name='xs'/>
			<Arguments/>
			<Iter>
				<Args>
					<Arguments>
						<Argument name='y'/>
					</Arguments>
				</Args>
				<Call name='match'>
					<Call name='to_s'>
						<Variable name='y'/>
						<Arguments/>
					</Call>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Iter>
		</Call>
	</Method>
	<Method name='say'>
		<Args>
			<Arguments>
				<Argument name='x'/>
			</Arguments>
		</Args>
		<Block>
			<Call name='puts'>
				<Args>
					<Variable name='x'/>
				</Args>
			</Call>
			<Rescue>
				<Body>
					<Nil name='nil'/>
				</Body>
				<Call name='system'>
					<Args>
						<String>
							<Str>say '</Str>
							<String>
								<Variable name='x'/>
							</String>
							<Str>'</Str>
						</String>
					</Args>
				</Call>
			</Rescue>
		</Block>
	</Method>
	<Method name='beep'>
		<Args/>
		<Block>
			<Call name='print'>
				<Args>
					<Str>BEEP </Str>
				</Args>
			</Call>
			<If>
				<Call name='!'>
					<Variable name='$testing'/>
					<Arguments/>
				</Call>
				<Rescue>
					<Body>
						<Nil name='nil'/>
					</Body>
					<Call name='system'>
						<Args>
							<Str>say 'beep'</Str>
						</Args>
					</Call>
				</Rescue>
			</If>
			<Str>beeped</Str>
		</Block>
	</Method>
	<Class>
		<Name name='Class'/>
		<Method name='blank?'>
			<Args/>
			<False/>
		</Method>
	</Class>
	<Class>
		<Name name='File'/>
		<Block>
			<Call name='require'>
				<Args>
					<Str>fileutils</Str>
				</Args>
			</Call>
			<Method name='to_s'>
				<Args/>
				<Variable name='path'/>
			</Method>
			<Method name='name'>
				<Args/>
				<Variable name='path'/>
			</Method>
			<Method name='filename'>
				<Args/>
				<Variable name='path'/>
			</Method>
			<Method name='mv'>
				<Args>
					<Arguments>
						<Argument name='to'/>
					</Arguments>
				</Args>
				<Call name='mv'>
					<Const name='FileUtils'/>
					<Args>
						<Variable name='path'/>
						<Variable name='to'/>
					</Args>
				</Call>
			</Method>
			<Method name='move'>
				<Args>
					<Arguments>
						<Argument name='to'/>
					</Arguments>
				</Args>
				<Call name='mv'>
					<Const name='FileUtils'/>
					<Args>
						<Variable name='path'/>
						<Variable name='to'/>
					</Args>
				</Call>
			</Method>
			<Method name='copy'>
				<Args>
					<Arguments>
						<Argument name='to'/>
					</Arguments>
				</Args>
				<Call name='cp'>
					<Const name='FileUtils'/>
					<Args>
						<Variable name='path'/>
						<Variable name='to'/>
					</Args>
				</Call>
			</Method>
			<Method name='cp'>
				<Args>
					<Arguments>
						<Argument name='to'/>
					</Arguments>
				</Args>
				<Call name='cp'>
					<Const name='FileUtils'/>
					<Args>
						<Variable name='path'/>
						<Variable name='to'/>
					</Args>
				</Call>
			</Method>
			<Method name='contain'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='index'>
					<Variable name='path'/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='contains'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='index'>
					<Variable name='path'/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='delete'>
				<Args/>
				<Call name='raise'>
					<Args>
						<Call name='SecurityError'>
							<Args>
								<Str>cannot delete files</Str>
							</Args>
						</Call>
					</Args>
				</Call>
			</Method>
			<Defs name='list'>
				<Self/>
				<Argument name='list'/>
				<Args>
					<Arguments>
						<Argument name='dir'/>
					</Arguments>
				</Args>
				<Call name='-'>
					<Call name='entries'>
						<Const name='Dir'/>
						<Args>
							<Variable name='dir'/>
						</Args>
					</Call>
					<Args>
						<Array>
							<Str>.</Str>
							<Str>..</Str>
						</Array>
					</Args>
				</Call>
			</Defs>
			<Defs name='ls'>
				<Self/>
				<Argument name='ls'/>
				<Args>
					<Arguments>
						<Argument name='dir'/>
					</Arguments>
				</Args>
				<Call name='-'>
					<Call name='entries'>
						<Const name='Dir'/>
						<Args>
							<Variable name='dir'/>
						</Args>
					</Call>
					<Args>
						<Array>
							<Str>.</Str>
							<Str>..</Str>
						</Array>
					</Args>
				</Call>
			</Defs>
		</Block>
	</Class>
	<Class>
		<Name name='Dir'/>
		<Block>
			<Method name='to_s'>
				<Args/>
				<Variable name='path'/>
			</Method>
			<Defs name='list'>
				<Self/>
				<Argument name='list'/>
				<Args>
					<Arguments>
						<Argument name='dir'/>
					</Arguments>
				</Args>
				<Call name='-'>
					<Call name='entries'>
						<Const name='Dir'/>
						<Args>
							<Variable name='dir'/>
						</Args>
					</Call>
					<Args>
						<Array>
							<Str>.</Str>
							<Str>..</Str>
						</Array>
					</Args>
				</Call>
			</Defs>
			<Defs name='ls'>
				<Self/>
				<Argument name='ls'/>
				<Args>
					<Arguments>
						<Argument name='dir'/>
					</Arguments>
				</Args>
				<Call name='-'>
					<Call name='entries'>
						<Const name='Dir'/>
						<Args>
							<Variable name='dir'/>
						</Args>
					</Call>
					<Args>
						<Array>
							<Str>.</Str>
							<Str>..</Str>
						</Array>
					</Args>
				</Call>
			</Defs>
			<Method name='list'>
				<Args/>
				<Call name='entries'>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
			<Method name='ls'>
				<Args/>
				<Call name='entries'>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
			<Method name='files'>
				<Args/>
				<Variable name='to_a'/>
			</Method>
			<Method name='contains'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='select'>
					<Arguments/>
					<Iter>
						<Args>
							<Arguments>
								<Argument name='f'/>
							</Arguments>
						</Args>
						<Call name='=='>
							<Variable name='f'/>
							<Args>
								<Variable name='x'/>
							</Args>
						</Call>
					</Iter>
				</Call>
			</Method>
			<Call name='require'>
				<Args>
					<Str>fileutils</Str>
				</Args>
			</Call>
			<Method name='remove_leaves'>
				<Args>
					<Block>
						<Argument(Default) value='#<Rjb::Rjb_JavaProxy:0x007f9b62895288>'/>
						<Argument(Default) value='#<Rjb::Rjb_JavaProxy:0x007f9b62894798>'/>
					</Block>
				</Args>
				<Call name='chdir'>
					<Const name='Dir'/>
					<Args>
						<Variable name='dir'/>
					</Args>
					<Iter>
						<Args/>
						<Block>
							<Assign name='entries'>
								<Call name='reject'>
									<Call name='entries'>
										<Const name='Dir'/>
										<Args>
											<Call name='pwd'>
												<Const name='Dir'/>
												<Arguments/>
											</Call>
										</Args>
									</Call>
									<Arguments/>
									<Iter>
										<Args>
											<Arguments>
												<Argument name='e'/>
											</Arguments>
										</Args>
										<Or>
											<Call name='=='>
												<Variable name='e'/>
												<Args>
													<Str>.</Str>
												</Args>
											</Call>
											<Call name='=='>
												<Variable name='e'/>
												<Args>
													<Str>..</Str>
												</Args>
											</Call>
										</Or>
									</Iter>
								</Call>
							</Assign>
							<If>
								<And>
									<Call name='=='>
										<Call name='size'>
											<Variable name='entries'/>
											<Arguments/>
										</Call>
										<Args>
											<Num value='1'/>
										</Args>
									</Call>
									<Call name='=='>
										<Call name='first'>
											<Variable name='entries'/>
											<Arguments/>
										</Call>
										<Args>
											<Variable name='matching'/>
										</Args>
									</Call>
								</And>
								<Block>
									<Call name='puts'>
										<Args>
											<String>
												<Str>Removing </Str>
												<String>
													<Call name='pwd'>
														<Const name='Dir'/>
														<Arguments/>
													</Call>
												</String>
											</String>
										</Args>
									</Call>
									<Call name='rm_rf'>
										<Const name='FileUtils'/>
										<Args>
											<Call name='pwd'>
												<Const name='Dir'/>
												<Arguments/>
											</Call>
										</Args>
									</Call>
								</Block>
								<Call name='each'>
									<Variable name='entries'/>
									<Arguments/>
									<Iter>
										<Args>
											<Arguments>
												<Argument name='e'/>
											</Arguments>
										</Args>
										<If>
											<Call name='directory?'>
												<Const name='File'/>
												<Args>
													<Variable name='e'/>
												</Args>
											</Call>
											<Call name='remove_leaves'>
												<Args>
													<Variable name='e'/>
												</Args>
											</Call>
										</If>
									</Iter>
								</Call>
							</If>
						</Block>
					</Iter>
				</Call>
			</Method>
			<Method name='delete'>
				<Args/>
				<Call name='raise'>
					<Args>
						<Call name='SecurityError'>
							<Args>
								<Str>cannot delete directories</Str>
							</Args>
						</Call>
					</Args>
				</Call>
			</Method>
		</Block>
	</Class>
	<Defs name='blank?'>
		<Nil name='nil'/>
		<Argument name='blank?'/>
		<Args/>
		<Return>
			<True/>
		</Return>
	</Defs>
	<Defs name='test'>
		<Nil name='nil'/>
		<Argument name='test'/>
		<Args/>
		<Str>nil.test OK</Str>
	</Defs>
	<Defs name='+'>
		<Nil name='nil'/>
		<Argument name='+'/>
		<Args>
			<Arguments>
				<Argument name='x'/>
			</Arguments>
		</Args>
		<Variable name='x'/>
	</Defs>
	<Class>
		<Name name='Hash'/>
		<Block>
			<Call name='alias_method'>
				<Args>
					<Symbol name='orig_index'/>
					<Symbol name='[]'/>
				</Args>
			</Call>
			<Method name='key?'>
				<Args>
					<Arguments>
						<Argument name='key'/>
					</Arguments>
				</Args>
				<Block>
					<If>
						<Call name='is_a?'>
							<Variable name='key'/>
							<Args>
								<Const name='Symbol'/>
							</Args>
						</Call>
						<Return>
							<Or>
								<Call name='contains'>
									<Variable name='keys'/>
									<Args>
										<Variable name='key'/>
									</Args>
								</Call>
								<Call name='contains'>
									<Variable name='keys'/>
									<Args>
										<Call name='to_s'>
											<Variable name='key'/>
											<Arguments/>
										</Call>
									</Args>
								</Call>
							</Or>
						</Return>
					</If>
					<If>
						<Call name='is_a?'>
							<Variable name='key'/>
							<Args>
								<Const name='String'/>
							</Args>
						</Call>
						<Return>
							<Or>
								<Call name='contains'>
									<Variable name='keys'/>
									<Args>
										<Variable name='key'/>
									</Args>
								</Call>
								<Call name='contains'>
									<Variable name='keys'/>
									<Args>
										<Call name='to_sym'>
											<Variable name='key'/>
											<Arguments/>
										</Call>
									</Args>
								</Call>
							</Or>
						</Return>
					</If>
					<Call name='contains'>
						<Variable name='keys'/>
						<Args>
							<Variable name='key'/>
						</Args>
					</Call>
				</Block>
			</Method>
			<Alias>
				<Literal name='has'/>
				<Literal name='key?'/>
			</Alias>
			<Alias>
				<Literal name='contains'/>
				<Literal name='key?'/>
			</Alias>
			<Method name='[]'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Block>
					<If>
						<Call name='!'>
							<Variable name='x'/>
							<Arguments/>
						</Call>
						<Return>
							<Nil name='nil'/>
						</Return>
					</If>
					<If>
						<Call name='is_a?'>
							<Variable name='x'/>
							<Args>
								<Const name='Symbol'/>
							</Args>
						</Call>
						<Return>
							<Or>
								<Call name='orig_index'>
									<Args>
										<Variable name='x'/>
									</Args>
								</Call>
								<Call name='orig_index'>
									<Args>
										<Call name='to_s'>
											<Variable name='x'/>
											<Arguments/>
										</Call>
									</Args>
								</Call>
							</Or>
						</Return>
					</If>
					<If>
						<Call name='is_a?'>
							<Variable name='x'/>
							<Args>
								<Const name='String'/>
							</Args>
						</Call>
						<Return>
							<Or>
								<Call name='orig_index'>
									<Args>
										<Variable name='x'/>
									</Args>
								</Call>
								<Call name='orig_index'>
									<Args>
										<Call name='to_sym'>
											<Variable name='x'/>
											<Arguments/>
										</Call>
									</Args>
								</Call>
							</Or>
						</Return>
					</If>
					<Call name='orig_index'>
						<Args>
							<Variable name='x'/>
						</Args>
					</Call>
				</Block>
			</Method>
			<Method name='map_values'>
				<Args/>
				<Call name='inject'>
					<Self/>
					<Args>
						<Hash>
							<Array/>
						</Hash>
					</Args>
					<Iter>
						<Args>
							<Arguments>
								<Argument name='newhash'/>
								<Assign>
									<Array>
										<Assign name='k'>
											<Nil name='nil'/>
										</Assign>
										<Assign name='v'>
											<Nil name='nil'/>
										</Assign>
									</Array>
								</Assign>
							</Arguments>
						</Args>
						<Block>
							<Assign name='[]='>
								<Variable name='newhash'/>
								<Array>
									<Variable name='k'/>
									<Yield>
										<Variable name='v'/>
									</Yield>
								</Array>
							</Assign>
							<Variable name='newhash'/>
						</Block>
					</Iter>
				</Call>
			</Method>
		</Block>
	</Class>
	<Class>
		<Name name='Class'/>
		<Method name='wrap'>
			<Args/>
			<Return>
				<Call name='to_s'>
					<Self/>
					<Arguments/>
				</Call>
			</Return>
		</Method>
	</Class>
	<Class>
		<Name name='Array'/>
		<Block>
			<Method name='c'>
				<Args/>
				<Call name='join'>
					<Call name='map'>
						<Argument>
							<Symbol name='c'/>
						</Argument>
					</Call>
					<Args>
						<Str>, </Str>
					</Args>
				</Call>
			</Method>
			<Method name='wrap'>
				<Args/>
				<String>
					<Str>rb_ary_new3(</Str>
					<String>
						<Variable name='size'/>
					</String>
					<Str>/*size*/, </Str>
					<String>
						<Variable name='wraps'/>
					</String>
					<Str>)</Str>
				</String>
			</Method>
			<Method name='wraps'>
				<Args/>
				<Call name='join'>
					<Call name='map'>
						<Argument>
							<Symbol name='wrap'/>
						</Argument>
					</Call>
					<Args>
						<Str>, </Str>
					</Args>
				</Call>
			</Method>
			<Method name='values'>
				<Args/>
				<Call name='join'>
					<Call name='map'>
						<Argument>
							<Symbol name='value'/>
						</Argument>
					</Call>
					<Args>
						<Str>, </Str>
					</Args>
				</Call>
			</Method>
			<Method name='contains_a'>
				<Args>
					<Arguments>
						<Argument name='type'/>
					</Arguments>
				</Args>
				<Block>
					<Call name='each'>
						<Arguments/>
						<Iter>
							<Args>
								<Arguments>
									<Argument name='x'/>
								</Arguments>
							</Args>
							<If>
								<Call name='is_a?'>
									<Variable name='x'/>
									<Args>
										<Variable name='type'/>
									</Args>
								</Call>
								<Return>
									<True/>
								</Return>
							</If>
						</Iter>
					</Call>
					<False/>
				</Block>
			</Method>
			<Method name='drop!'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='reject!'>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='to_str'>
				<Args/>
				<Call name='join'>
					<Self/>
					<Args>
						<Str>, </Str>
					</Args>
				</Call>
			</Method>
			<Method name='method_missing'>
				<Args>
					<Arguments>
						<Argument name='method'/>
					</Arguments>
					<Argument name='args'/>
					<Argument name='block'/>
				</Args>
				<Block>
					<If>
						<Call name='=='>
							<Call name='count'>
								<Variable name='args'/>
								<Arguments/>
							</Call>
							<Args>
								<Num value='0'/>
							</Args>
						</Call>
						<Return>
							<Call name='map'>
								<Self/>
								<Arguments/>
								<Iter>
									<Args>
										<Arguments>
											<Argument name='x'/>
										</Arguments>
									</Args>
									<Call name='send'>
										<Variable name='x'/>
										<Args>
											<Variable name='method'/>
										</Args>
									</Call>
								</Iter>
							</Call>
						</Return>
					</If>
					<If>
						<Call name='>'>
							<Call name='count'>
								<Variable name='args'/>
								<Arguments/>
							</Call>
							<Args>
								<Num value='0'/>
							</Args>
						</Call>
						<Return>
							<Call name='map'>
								<Self/>
								<Arguments/>
								<Iter>
									<Args>
										<Arguments>
											<Argument name='x'/>
										</Arguments>
									</Args>
									<Call name='send'>
										<Variable name='x'/>
										<Args>
											<Variable name='method'/>
											<Variable name='args'/>
										</Args>
									</Call>
								</Iter>
							</Call>
						</Return>
					</If>
					<Super>
						<Args>
							<Array>
								<Variable name='method'/>
							</Array>
							<Variable name='args'/>
						</Args>
						<Argument>
							<Args>
								<Array>
									<Variable name='method'/>
								</Array>
								<Variable name='args'/>
							</Args>
							<Variable name='block'/>
						</Argument>
					</Super>
				</Block>
			</Method>
			<Method name='matches'>
				<Args>
					<Arguments>
						<Argument name='regex'/>
					</Arguments>
				</Args>
				<Block>
					<For>
						<Assign name='i'>
							<Nil name='nil'/>
						</Assign>
						<Block>
							<Assign name='m'>
								<Call name='match'>
									<Variable name='regex'/>
									<Args>
										<Call name='gsub'>
											<Variable name='i'/>
											<Args>
												<Regexp>([^\w])</Regexp>
												<Str>\\\1</Str>
											</Args>
										</Call>
									</Args>
								</Call>
							</Assign>
							<If>
								<Variable name='m'/>
								<Return>
									<Variable name='m'/>
								</Return>
							</If>
						</Block>
						<Call name='flatten'>
							<Self/>
							<Arguments/>
						</Call>
					</For>
					<Return>
						<False/>
					</Return>
				</Block>
			</Method>
			<Method name='and'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Block>
					<If>
						<Call name='!'>
							<Call name='is_a?'>
								<Variable name='x'/>
								<Args>
									<Const name='Array'/>
								</Args>
							</Call>
							<Arguments/>
						</Call>
						<Call name='+'>
							<Self/>
							<Args>
								<Array>
									<Variable name='x'/>
								</Array>
							</Args>
						</Call>
					</If>
					<Call name='+'>
						<Self/>
						<Args>
							<Variable name='x'/>
						</Args>
					</Call>
				</Block>
			</Method>
			<Method name='plus'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Block>
					<If>
						<Call name='!'>
							<Call name='is_a?'>
								<Variable name='x'/>
								<Args>
									<Const name='Array'/>
								</Args>
							</Call>
							<Arguments/>
						</Call>
						<Call name='+'>
							<Self/>
							<Args>
								<Array>
									<Variable name='x'/>
								</Array>
							</Args>
						</Call>
					</If>
					<Call name='+'>
						<Self/>
						<Args>
							<Variable name='x'/>
						</Args>
					</Call>
				</Block>
			</Method>
			<Method name='blank?'>
				<Args/>
				<Or>
					<Call name='nil?'>
						<Arguments/>
					</Call>
					<Call name='empty?'>
						<Arguments/>
					</Call>
				</Or>
			</Method>
			<Method name='names'>
				<Args/>
				<Call name='map'>
					<Argument>
						<Symbol name='to_s'/>
					</Argument>
				</Call>
			</Method>
			<Method name='rest'>
				<Args/>
				<Call name='[]'>
					<Args>
						<Dot>
							<Num value='1'/>
							<Num value='-1'/>
						</Dot>
					</Args>
				</Call>
			</Method>
			<Method name='fix_int'>
				<Args>
					<Arguments>
						<Argument name='i'/>
					</Arguments>
				</Args>
				<Block>
					<If>
						<Call name='=='>
							<Call name='to_s'>
								<Variable name='i'/>
								<Arguments/>
							</Call>
							<Args>
								<Str>middle</Str>
							</Args>
						</Call>
						<Assign name='i'>
							<Call name='/'>
								<Variable name='count'/>
								<Args>
									<Num value='2'/>
								</Args>
							</Call>
						</Assign>
					</If>
					<If>
						<Call name='is_a?'>
							<Variable name='i'/>
							<Args>
								<Const name='Numeric'/>
							</Args>
						</Call>
						<Return>
							<Call name='-'>
								<Variable name='i'/>
								<Args>
									<Num value='1'/>
								</Args>
							</Call>
						</Return>
					</If>
					<Assign name='i'>
						<Call name='to_i'>
							<Call name='replace_numerals!'>
								<Call name='to_s'>
									<Variable name='i'/>
									<Arguments/>
								</Call>
								<Arguments/>
							</Call>
							<Arguments/>
						</Call>
					</Assign>
					<Call name='-'>
						<Variable name='i'/>
						<Args>
							<Num value='1'/>
						</Args>
					</Call>
				</Block>
			</Method>
			<Method name='character'>
				<Args>
					<Arguments>
						<Argument name='nr'/>
					</Arguments>
				</Args>
				<Call name='item'>
					<Args>
						<Variable name='nr'/>
					</Args>
				</Call>
			</Method>
			<Method name='item'>
				<Args>
					<Arguments>
						<Argument name='nr'/>
					</Arguments>
				</Args>
				<Call name='[]'>
					<Args>
						<Call name='fix_int'>
							<Args>
								<Variable name='nr'/>
							</Args>
						</Call>
					</Args>
				</Call>
			</Method>
			<Method name='word'>
				<Args>
					<Arguments>
						<Argument name='nr'/>
					</Arguments>
				</Args>
				<Call name='[]'>
					<Args>
						<Call name='fix_int'>
							<Args>
								<Variable name='nr'/>
							</Args>
						</Call>
					</Args>
				</Call>
			</Method>
			<Method name='invert'>
				<Args/>
				<Variable name='reverse'/>
			</Method>
			<Method name='get'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='[]'>
					<Args>
						<Call name='index'>
							<Args>
								<Variable name='x'/>
							</Args>
						</Call>
					</Args>
				</Call>
			</Method>
			<Method name='row'>
				<Args>
					<Arguments>
						<Argument name='n'/>
					</Arguments>
				</Args>
				<Call name='at'>
					<Args>
						<Variable name='n'/>
					</Args>
				</Call>
			</Method>
			<Method name='has'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='index'>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='contains'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Block>
					<Assign name='ok'>
						<Call name='index'>
							<Args>
								<Variable name='x'/>
							</Args>
						</Call>
					</Assign>
					<If>
						<Variable name='ok'/>
						<Call name='at'>
							<Args>
								<Call name='index'>
									<Args>
										<Variable name='x'/>
									</Args>
								</Call>
							</Args>
						</Call>
						<False/>
					</If>
				</Block>
			</Method>
		</Block>
	</Class>
	<Class>
		<Name name='TrueClass'/>
		<Method name='blank?'>
			<Args/>
			<False/>
		</Method>
	</Class>
	<Class>
		<Name name='FalseClass'/>
		<Block>
			<Method name='blank?'>
				<Args/>
				<True/>
			</Method>
			<Method name='wrap'>
				<Args/>
				<Self/>
			</Method>
			<Method name='c'>
				<Args/>
				<Self/>
			</Method>
		</Block>
	</Class>
	<Class>
		<Name name='String'/>
		<Block>
			<Method name='fix_encoding'>
				<Args/>
				<Block>
					<If>
						<Call name='method_defined?'>
							<Const name='String'/>
							<Args>
								<Symbol name='encode'/>
							</Args>
						</Call>
						<Call name='require'>
							<Args>
								<Str>iconv</Str>
							</Args>
						</Call>
					</If>
					<If>
						<Call name='method_defined?'>
							<Const name='String'/>
							<Args>
								<Symbol name='encode'/>
							</Args>
						</Call>
						<Return>
							<Call name='encode!'>
								<Self/>
								<Args>
									<Str>UTF-8</Str>
									<Str>UTF-8</Str>
									<Hash>
										<Array>
											<Symbol name='invalid'/>
											<Symbol name='replace'/>
										</Array>
									</Hash>
								</Args>
							</Call>
						</Return>
						<Block>
							<Assign name='ic'>
								<Call name='new'>
									<Const name='Iconv'/>
									<Args>
										<Str>UTF-8</Str>
										<Str>UTF-8//IGNORE</Str>
									</Args>
								</Call>
							</Assign>
							<Return>
								<Call name='iconv'>
									<Variable name='ic'/>
									<Args>
										<Self/>
									</Args>
								</Call>
							</Return>
						</Block>
					</If>
				</Block>
			</Method>
			<Method name='c'>
				<Args/>
				<Variable name='quoted'/>
			</Method>
			<Method name='quoted'>
				<Args/>
				<String>
					<Str>"</Str>
					<String>
						<Self/>
					</String>
					<Str>"</Str>
				</String>
			</Method>
			<Method name='id'>
				<Args/>
				<String>
					<Str>id("</Str>
					<String>
						<Self/>
					</String>
					<Str>")</Str>
				</String>
			</Method>
			<Method name='wrap'>
				<Args/>
				<String>
					<Str>s("</Str>
					<String>
						<Self/>
					</String>
					<Str>")</Str>
				</String>
			</Method>
			<Method name='value'>
				<Args/>
				<Self/>
			</Method>
			<Method name='name'>
				<Args/>
				<Self/>
			</Method>
			<Method name='number'>
				<Args/>
				<Call name='to_i'>
					<Self/>
					<Arguments/>
				</Call>
			</Method>
			<Method name='in'>
				<Args>
					<Arguments>
						<Argument name='ary'/>
					</Arguments>
				</Args>
				<Call name='has'>
					<Variable name='ary'/>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
			<Method name='matches'>
				<Args>
					<Arguments>
						<Argument name='regex'/>
					</Arguments>
				</Args>
				<Block>
					<If>
						<Call name='is_a?'>
							<Variable name='regex'/>
							<Args>
								<Const name='Array'/>
							</Args>
						</Call>
						<Call name='each'>
							<Variable name='regex'/>
							<Arguments/>
							<Iter>
								<Args>
									<Arguments>
										<Argument name='x'/>
									</Arguments>
								</Args>
								<Block>
									<Assign name='z'>
										<Call name='match'>
											<Args>
												<Variable name='x'/>
											</Args>
										</Call>
									</Assign>
									<If>
										<Variable name='z'/>
										<Return>
											<Variable name='x'/>
										</Return>
									</If>
								</Block>
							</Iter>
						</Call>
						<Call name='match'>
							<Args>
								<Variable name='regex'/>
							</Args>
						</Call>
					</If>
					<Return>
						<False/>
					</Return>
				</Block>
			</Method>
			<Method name='stripNewline'>
				<Args/>
				<Call name='sub'>
					<Variable name='strip'/>
					<Args>
						<Regexp>;$</Regexp>
						<Str></Str>
					</Args>
				</Call>
			</Method>
			<Method name='join'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Self/>
			</Method>
			<Method name='starts_with?'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Block>
					<If>
						<Call name='is_a?'>
							<Variable name='x'/>
							<Args>
								<Const name='Array'/>
							</Args>
						</Call>
						<Call name='each'>
							<Variable name='x'/>
							<Arguments/>
							<Iter>
								<Args>
									<Arguments>
										<Argument name='y'/>
									</Arguments>
								</Args>
								<If>
									<Call name='start_with?'>
										<Args>
											<Variable name='y'/>
										</Args>
									</Call>
									<Return>
										<Variable name='y'/>
									</Return>
								</If>
							</Iter>
						</Call>
					</If>
					<Return>
						<Call name='start_with?'>
							<Args>
								<Variable name='x'/>
							</Args>
						</Call>
					</Return>
				</Block>
			</Method>
			<Method name='show'>
				<Args>
					<Block>
						<Argument(Default) value='#<Rjb::Rjb_JavaProxy:0x007f9b63090398>'/>
					</Block>
				</Args>
				<Block>
					<Call name='puts'>
						<Args>
							<Or>
								<Variable name='x'/>
								<Self/>
							</Or>
						</Args>
					</Call>
					<Return>
						<Or>
							<Variable name='x'/>
							<Self/>
						</Or>
					</Return>
				</Block>
			</Method>
			<Method name='contains'>
				<Args>
					<Argument name='things'/>
				</Args>
				<Block>
					<For>
						<Assign name='t'>
							<Nil name='nil'/>
						</Assign>
						<If>
							<Call name='index'>
								<Args>
									<Variable name='t'/>
								</Args>
							</Call>
							<Return>
								<True/>
							</Return>
						</If>
						<Call name='flatten'>
							<Variable name='things'/>
							<Arguments/>
						</Call>
					</For>
					<Return>
						<False/>
					</Return>
				</Block>
			</Method>
			<Method name='fix_int'>
				<Args>
					<Arguments>
						<Argument name='i'/>
					</Arguments>
				</Args>
				<Block>
					<If>
						<Call name='=='>
							<Call name='to_s'>
								<Variable name='i'/>
								<Arguments/>
							</Call>
							<Args>
								<Str>middle</Str>
							</Args>
						</Call>
						<Assign name='i'>
							<Call name='/'>
								<Variable name='count'/>
								<Args>
									<Num value='2'/>
								</Args>
							</Call>
						</Assign>
					</If>
					<If>
						<Call name='is_a?'>
							<Variable name='i'/>
							<Args>
								<Const name='Numeric'/>
							</Args>
						</Call>
						<Return>
							<Call name='-'>
								<Variable name='i'/>
								<Args>
									<Num value='1'/>
								</Args>
							</Call>
						</Return>
					</If>
					<Assign name='i'>
						<Call name='to_i'>
							<Call name='replace_numerals!'>
								<Call name='to_s'>
									<Variable name='i'/>
									<Arguments/>
								</Call>
								<Arguments/>
							</Call>
							<Arguments/>
						</Call>
					</Assign>
					<Call name='-'>
						<Variable name='i'/>
						<Args>
							<Num value='1'/>
						</Args>
					</Call>
				</Block>
			</Method>
			<Method name='sentence'>
				<Args>
					<Arguments>
						<Argument name='i'/>
					</Arguments>
				</Args>
				<Block>
					<Assign name='i'>
						<Call name='fix_int'>
							<Args>
								<Variable name='i'/>
							</Args>
						</Call>
					</Assign>
					<Call name='[]'>
						<Call name='split'>
							<Args>
								<Regexp>[\.\?\!\;]</Regexp>
							</Args>
						</Call>
						<Args>
							<Variable name='i'/>
						</Args>
					</Call>
				</Block>
			</Method>
			<Method name='paragraph'>
				<Args>
					<Arguments>
						<Argument name='i'/>
					</Arguments>
				</Args>
				<Block>
					<Assign name='i'>
						<Call name='fix_int'>
							<Args>
								<Variable name='i'/>
							</Args>
						</Call>
					</Assign>
					<Call name='[]'>
						<Call name='split'>
							<Args>
								<Str>
</Str>
							</Args>
						</Call>
						<Args>
							<Variable name='i'/>
						</Args>
					</Call>
				</Block>
			</Method>
			<Method name='word'>
				<Args>
					<Arguments>
						<Argument name='i'/>
					</Arguments>
				</Args>
				<Block>
					<Assign name='i'>
						<Call name='fix_int'>
							<Args>
								<Variable name='i'/>
							</Args>
						</Call>
					</Assign>
					<Call name='[]'>
						<Call name='split'>
							<Args>
								<Str> </Str>
							</Args>
						</Call>
						<Args>
							<Variable name='i'/>
						</Args>
					</Call>
				</Block>
			</Method>
			<Method name='item'>
				<Args>
					<Arguments>
						<Argument name='i'/>
					</Arguments>
				</Args>
				<Call name='word'>
					<Args>
						<Variable name='i'/>
					</Args>
				</Call>
			</Method>
			<Method name='char'>
				<Args>
					<Arguments>
						<Argument name='i'/>
					</Arguments>
				</Args>
				<Call name='character'>
					<Args>
						<Variable name='i'/>
					</Args>
				</Call>
			</Method>
			<Method name='character'>
				<Args>
					<Arguments>
						<Argument name='i'/>
					</Arguments>
				</Args>
				<Block>
					<Assign name='i'>
						<Call name='fix_int'>
							<Args>
								<Variable name='i'/>
							</Args>
						</Call>
					</Assign>
					<Call name='[]'>
						<Args>
							<Dot>
								<Call name='-'>
									<Variable name='i'/>
									<Args>
										<Num value='1'/>
									</Args>
								</Call>
								<Variable name='i'/>
							</Dot>
						</Args>
					</Call>
				</Block>
			</Method>
			<Method name='flip'>
				<Args/>
				<Call name='join'>
					<Call name='reverse'>
						<Call name='split'>
							<Args>
								<Str> </Str>
							</Args>
						</Call>
						<Arguments/>
					</Call>
					<Args>
						<Str> </Str>
					</Args>
				</Call>
			</Method>
			<Method name='invert'>
				<Args/>
				<Variable name='reverse'/>
			</Method>
			<Method name='plus'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='+'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='and'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='+'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='add'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='+'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='offset'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='index'>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='-'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='gsub'>
					<Self/>
					<Args>
						<Variable name='x'/>
						<Str></Str>
					</Args>
				</Call>
			</Method>
			<Method name='is_noun'>
				<Args/>
				<Rescue>
					<Body>
						<False/>
					</Body>
					<Or>
						<Call name='!'>
							<Call name='empty?'>
								<Call name='synsets'>
									<Args>
										<Symbol name='noun'/>
									</Args>
								</Call>
								<Arguments/>
							</Call>
							<Arguments/>
						</Call>
						<Call name='!'>
							<Call name='empty?'>
								<Call name='synsets'>
									<Call name='gsub'>
										<Self/>
										<Args>
											<Regexp>s$</Regexp>
											<Str></Str>
										</Args>
									</Call>
									<Args>
										<Symbol name='noun'/>
									</Args>
								</Call>
								<Arguments/>
							</Call>
							<Arguments/>
						</Call>
					</Or>
				</Rescue>
			</Method>
			<Method name='is_verb'>
				<Args/>
				<Block>
					<Call name='!'>
						<Call name='empty?'>
							<Call name='synsets'>
								<Args>
									<Symbol name='verb'/>
								</Args>
							</Call>
							<Args>
								<Variable name='of'/>
							</Args>
						</Call>
						<Arguments/>
					</Call>
					<Call name='!'>
						<Call name='empty?'>
							<Call name='synsets'>
								<Call name='gsub'>
									<Self/>
									<Args>
										<Regexp>s$</Regexp>
										<Str></Str>
									</Args>
								</Call>
								<Args>
									<Symbol name='verb'/>
								</Args>
							</Call>
							<Arguments/>
						</Call>
						<Arguments/>
					</Call>
				</Block>
			</Method>
			<Method name='is_a'>
				<Args>
					<Arguments>
						<Argument name='className'/>
					</Arguments>
				</Args>
				<Block>
					<Call name='downcase!'>
						<Variable name='className'/>
						<Arguments/>
					</Call>
					<If>
						<Call name='=='>
							<Variable name='className'/>
							<Args>
								<Str>quote</Str>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<Return>
						<Call name='=='>
							<Variable name='className'/>
							<Args>
								<Str>string</Str>
							</Args>
						</Call>
					</Return>
				</Block>
			</Method>
			<Method name='is_adverb'>
				<Args/>
				<Call name='!'>
					<Call name='empty?'>
						<Call name='synsets'>
							<Args>
								<Symbol name='adverb'/>
							</Args>
						</Call>
						<Arguments/>
					</Call>
					<Arguments/>
				</Call>
			</Method>
			<Method name='is_adjective'>
				<Args/>
				<Call name='!'>
					<Call name='empty?'>
						<Call name='synsets'>
							<Args>
								<Symbol name='adjective'/>
							</Args>
						</Call>
						<Arguments/>
					</Call>
					<Arguments/>
				</Call>
			</Method>
			<Method name='examples'>
				<Args/>
				<Call name='map'>
					<Call name='uniq'>
						<Call name='flatten'>
							<Call name='map'>
								<Call name='flatten'>
									<Call name='map'>
										<Call name='flatten'>
											<Variable name='synsets'/>
											<Arguments/>
										</Call>
										<Argument>
											<Symbol name='hyponyms'/>
										</Argument>
									</Call>
									<Arguments/>
								</Call>
								<Argument>
									<Symbol name='words'/>
								</Argument>
							</Call>
							<Arguments/>
						</Call>
						<Arguments/>
					</Call>
					<Argument>
						<Symbol name='to_s'/>
					</Argument>
				</Call>
			</Method>
			<Method name='blank?'>
				<Args/>
				<Or>
					<Call name='nil?'>
						<Arguments/>
					</Call>
					<Call name='empty?'>
						<Arguments/>
					</Call>
				</Or>
			</Method>
			<Method name='lowercase'>
				<Args/>
				<Variable name='downcase'/>
			</Method>
			<Method name='lowercase!'>
				<Args/>
				<Call name='downcase!'>
					<Arguments/>
				</Call>
			</Method>
			<Method name='shift'>
				<Args>
					<Block>
						<Argument(Default) value='#<Rjb::Rjb_JavaProxy:0x007f9b6390bea0>'/>
					</Block>
				</Args>
				<Call name='times'>
					<Variable name='n'/>
					<Arguments/>
					<Iter>
						<Args/>
						<Call name='gsub!'>
							<Self/>
							<Args>
								<Regexp>^.</Regexp>
								<Str></Str>
							</Args>
						</Call>
					</Iter>
				</Call>
			</Method>
			<Method name='replace_numerals!'>
				<Args/>
				<Block>
					<Call name='gsub!'>
						<Args>
							<Regexp>([a-z])-([a-z])</Regexp>
							<Str>\1+\2</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>last</Str>
							<Str>0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>first</Str>
							<Str>1</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>tenth</Str>
							<Str>10</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>ninth</Str>
							<Str>9</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>eighth</Str>
							<Str>8</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>seventh</Str>
							<Str>7</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>sixth</Str>
							<Str>6</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>fifth</Str>
							<Str>5</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>fourth</Str>
							<Str>4</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>third</Str>
							<Str>3</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>second</Str>
							<Str>2</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>first</Str>
							<Str>1</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>zero</Str>
							<Str>0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>4th</Str>
							<Str>4</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>3rd</Str>
							<Str>3</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>2nd</Str>
							<Str>2</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>1st</Str>
							<Str>1</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>(d+)th</Str>
							<Str>\1</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>(d+)rd</Str>
							<Str>\1</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>(d+)nd</Str>
							<Str>\1</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>(d+)st</Str>
							<Str>\1</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>a couple of</Str>
							<Str>2</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>a dozen</Str>
							<Str>12</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>ten</Str>
							<Str>10</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>twenty</Str>
							<Str>20</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>thirty</Str>
							<Str>30</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>forty</Str>
							<Str>40</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>fifty</Str>
							<Str>50</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>sixty</Str>
							<Str>60</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>seventy</Str>
							<Str>70</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>eighty</Str>
							<Str>80</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>ninety</Str>
							<Str>90</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>ten</Str>
							<Str>10</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>eleven</Str>
							<Str>11</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>twelve</Str>
							<Str>12</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>thirteen</Str>
							<Str>13</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>fourteen</Str>
							<Str>14</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>fifteen</Str>
							<Str>15</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>sixteen</Str>
							<Str>16</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>seventeen</Str>
							<Str>17</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>eighteen</Str>
							<Str>18</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>nineteen</Str>
							<Str>19</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>ten</Str>
							<Str>10</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>nine</Str>
							<Str>9</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>eight</Str>
							<Str>8</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>seven</Str>
							<Str>7</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>six</Str>
							<Str>6</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>five</Str>
							<Str>5</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>four</Str>
							<Str>4</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>three</Str>
							<Str>3</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>two</Str>
							<Str>2</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>one</Str>
							<Str>1</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>dozen</Str>
							<Str>12</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>couple</Str>
							<Str>2</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>½</Str>
							<Str>+1/2.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅓</Str>
							<Str>+1/3.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅔</Str>
							<Str>+2/3.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>¼</Str>
							<Str>+1/4.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>¾</Str>
							<Str>+3/4.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅕</Str>
							<Str>+1/5.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅖</Str>
							<Str>+2/5.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅗</Str>
							<Str>+3/5.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅘</Str>
							<Str>+4/5.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅙</Str>
							<Str>+1/6.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅚</Str>
							<Str>+5/6.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅛</Str>
							<Str>+1/8.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅜</Str>
							<Str>+3/8.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅝</Str>
							<Str>+5/8.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>⅞</Str>
							<Str>+7/8.0</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str> hundred thousand</Str>
							<Str> 100000</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str> hundred</Str>
							<Str> 100</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str> thousand</Str>
							<Str> 1000</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str> million</Str>
							<Str> 1000000</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str> billion</Str>
							<Str> 1000000000</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>hundred thousand</Str>
							<Str>*100000</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>hundred </Str>
							<Str>*100</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>thousand </Str>
							<Str>*1000</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>million </Str>
							<Str>*1000000</Str>
						</Args>
					</Call>
					<Call name='gsub!'>
						<Args>
							<Str>billion </Str>
							<Str>*1000000000</Str>
						</Args>
					</Call>
					<Self/>
				</Block>
			</Method>
			<Method name='parse_integer'>
				<Args/>
				<Block>
					<Call name='replace_numerals!'>
						<Arguments/>
					</Call>
					<Assign name='i'>
						<Call name='to_i'>
							<Call name='eval'>
								<Args>
									<Self/>
								</Args>
							</Call>
							<Arguments/>
						</Call>
					</Assign>
					<Variable name='i'/>
				</Block>
			</Method>
			<Method name='parse_number'>
				<Args/>
				<Block>
					<Call name='replace_numerals!'>
						<Arguments/>
					</Call>
					<Call name='to_f'>
						<Call name='eval'>
							<Args>
								<Self/>
							</Args>
						</Call>
						<Arguments/>
					</Call>
				</Block>
			</Method>
		</Block>
	</Class>
	<Class>
		<Name name='Numeric'/>
		<Block>
			<Method name='c'>
				<Args/>
				<Call name='to_s'>
					<Self/>
					<Arguments/>
				</Call>
			</Method>
			<Method name='to_sym'>
				<Args/>
				<Call name='to_sym'>
					<Variable name='to_s'/>
					<Arguments/>
				</Call>
			</Method>
			<Method name='value'>
				<Args/>
				<Self/>
			</Method>
			<Method name='wrap'>
				<Args/>
				<String>
					<Str>INT2NUM(</Str>
					<String>
						<Call name='to_s'>
							<Self/>
							<Arguments/>
						</Call>
					</String>
					<Str>)</Str>
				</String>
			</Method>
			<Method name='number'>
				<Args/>
				<Self/>
			</Method>
			<Method name='and'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='+'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='plus'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='+'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='minus'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='-'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='times'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='*'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='<'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Block>
					<If>
						<Call name='is_a?'>
							<Variable name='x'/>
							<Args>
								<Const name='String'/>
							</Args>
						</Call>
						<Return>
							<Call name='<'>
								<Self/>
								<Args>
									<Call name='to_i'>
										<Variable name='x'/>
										<Arguments/>
									</Call>
								</Args>
							</Call>
						</Return>
					</If>
					<Call name='<'>
						<Super/>
						<Args>
							<Variable name='x'/>
						</Args>
					</Call>
				</Block>
			</Method>
			<Method name='blank?'>
				<Args/>
				<Return>
					<False/>
				</Return>
			</Method>
			<Method name='is_a'>
				<Args>
					<Arguments>
						<Argument name='clazz'/>
					</Arguments>
				</Args>
				<Block>
					<Assign name='className'>
						<Call name='downcase'>
							<Call name='to_s'>
								<Variable name='clazz'/>
								<Arguments/>
							</Call>
							<Arguments/>
						</Call>
					</Assign>
					<If>
						<Call name='=='>
							<Variable name='className'/>
							<Args>
								<Str>number</Str>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<Call name='=='>
							<Variable name='className'/>
							<Args>
								<Str>real</Str>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<Call name='=='>
							<Variable name='className'/>
							<Args>
								<Str>float</Str>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<And>
							<Call name='is_a?'>
								<Self/>
								<Args>
									<Const name='Integer'/>
								</Args>
							</Call>
							<Call name='=='>
								<Variable name='className'/>
								<Args>
									<Str>integer</Str>
								</Args>
							</Call>
						</And>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<And>
							<Call name='is_a?'>
								<Self/>
								<Args>
									<Const name='Integer'/>
								</Args>
							</Call>
							<Call name='=='>
								<Variable name='className'/>
								<Args>
									<Str>int</Str>
								</Args>
							</Call>
						</And>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<Call name='=='>
							<Variable name='className'/>
							<Args>
								<Call name='downcase'>
									<Call name='to_s'>
										<Self/>
										<Arguments/>
									</Call>
									<Arguments/>
								</Call>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<Call name='is'>
							<Self/>
							<Args>
								<Variable name='clazz'/>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<Return>
						<False/>
					</Return>
				</Block>
			</Method>
			<Method name='add'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='+'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='increase'>
				<Args>
					<Block>
						<Argument(Default) value='#<Rjb::Rjb_JavaProxy:0x007f9b61a99170>'/>
					</Block>
				</Args>
				<Call name='+'>
					<Self/>
					<Args>
						<Or>
							<Variable name='by'/>
							<Num value='1'/>
						</Or>
					</Args>
				</Call>
			</Method>
			<Method name='decrease'>
				<Args>
					<Block>
						<Argument(Default) value='#<Rjb::Rjb_JavaProxy:0x007f9b61a819a8>'/>
					</Block>
				</Args>
				<Call name='-'>
					<Self/>
					<Args>
						<Or>
							<Variable name='by'/>
							<Num value='1'/>
						</Or>
					</Args>
				</Call>
			</Method>
			<Method name='bigger?'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='>'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='smaller?'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='<'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='to_the_power_of'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='**'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='to_the'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='**'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='logarithm'>
				<Args/>
				<Call name='log'>
					<Const name='Math'/>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
			<Method name='e'>
				<Args/>
				<Call name='exp'>
					<Const name='Math'/>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
			<Method name='exponential'>
				<Args/>
				<Call name='exp'>
					<Const name='Math'/>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
			<Method name='sine'>
				<Args/>
				<Call name='sin'>
					<Const name='Math'/>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
			<Method name='cosine'>
				<Args/>
				<Call name='cos'>
					<Const name='Math'/>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
			<Method name='root'>
				<Args/>
				<Call name='sqrt'>
					<Const name='Math'/>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
			<Method name='power'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='**'>
					<Self/>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='square'>
				<Args/>
				<Call name='*'>
					<Self/>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
			<Method name='squared'>
				<Args/>
				<Call name='*'>
					<Self/>
					<Args>
						<Self/>
					</Args>
				</Call>
			</Method>
		</Block>
	</Class>
	<Class>
		<Name name='Object'/>
		<Block>
			<Method name='class_name'>
				<Args/>
				<Or>
					<Call name='last'>
						<Call name='split'>
							<Call name='name'>
								<Call name='class'>
									<Self/>
									<Arguments/>
								</Call>
								<Arguments/>
							</Call>
							<Args>
								<Str>::</Str>
							</Args>
						</Call>
						<Arguments/>
					</Call>
					<Str></Str>
				</Or>
			</Method>
			<Method name='short_name'>
				<Args/>
				<Or>
					<Call name='last'>
						<Call name='split'>
							<Call name='name'>
								<Call name='class'>
									<Self/>
									<Arguments/>
								</Call>
								<Arguments/>
							</Call>
							<Args>
								<Str>::</Str>
							</Args>
						</Call>
						<Arguments/>
					</Call>
					<Str></Str>
				</Or>
			</Method>
			<Method name='name'>
				<Args/>
				<Variable name='to_s'/>
			</Method>
			<Method name='value'>
				<Args/>
				<Self/>
			</Method>
			<Method name='number'>
				<Args/>
				<False/>
			</Method>
			<Method name='blank?'>
				<Args/>
				<False/>
			</Method>
			<Defs name='throw'>
				<Self/>
				<Argument name='throw'/>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Call name='raise'>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Defs>
			<Method name='type'>
				<Args/>
				<Call name='class'>
					<Self/>
					<Arguments/>
				</Call>
			</Method>
			<Method name='kind'>
				<Args/>
				<Call name='class'>
					<Self/>
					<Arguments/>
				</Call>
			</Method>
			<Method name='log'>
				<Args>
					<Argument name='x'/>
				</Args>
				<Call name='puts'>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='debug'>
				<Args>
					<Argument name='x'/>
				</Args>
				<Call name='puts'>
					<Args>
						<Variable name='x'/>
					</Args>
				</Call>
			</Method>
			<Method name='is_a'>
				<Args>
					<Arguments>
						<Argument name='clazz'/>
					</Arguments>
				</Args>
				<Block>
					<Assign name='className'>
						<Call name='downcase'>
							<Call name='to_s'>
								<Variable name='clazz'/>
								<Arguments/>
							</Call>
							<Arguments/>
						</Call>
					</Assign>
					<Begin>
						<Rescue>
							<Body>
								<Call name='puts'>
									<Args>
										<Variable name='$!'/>
									</Args>
								</Call>
							</Body>
							<Block>
								<Assign name='ok'>
									<Call name='is_a?'>
										<Self/>
										<Args>
											<Variable name='clazz'/>
										</Args>
									</Call>
								</Assign>
								<If>
									<Variable name='ok'/>
									<Return>
										<True/>
									</Return>
								</If>
							</Block>
						</Rescue>
					</Begin>
					<If>
						<Call name='=='>
							<Variable name='className'/>
							<Args>
								<Call name='downcase'>
									<Call name='to_s'>
										<Self/>
										<Arguments/>
									</Call>
									<Arguments/>
								</Call>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<Call name='is'>
							<Self/>
							<Args>
								<Variable name='clazz'/>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<Return>
						<False/>
					</Return>
				</Block>
			</Method>
			<Method name='is'>
				<Args>
					<Arguments>
						<Argument name='x'/>
					</Arguments>
				</Args>
				<Block>
					<If>
						<And>
							<Call name='blank?'>
								<Variable name='x'/>
								<Arguments/>
							</Call>
							<Call name='blank?'>
								<Self/>
								<Arguments/>
							</Call>
						</And>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<Call name='=='>
							<Variable name='x'/>
							<Args>
								<Self/>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<Call name='==='>
							<Variable name='x'/>
							<Args>
								<Self/>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<Call name='=='>
							<Call name='downcase'>
								<Call name='to_s'>
									<Variable name='x'/>
									<Arguments/>
								</Call>
								<Arguments/>
							</Call>
							<Args>
								<Call name='downcase'>
									<Call name='to_s'>
										<Self/>
										<Arguments/>
									</Call>
									<Arguments/>
								</Call>
							</Args>
						</Call>
						<Return>
							<True/>
						</Return>
					</If>
					<If>
						<And>
							<Call name='is_a?'>
								<Self/>
								<Args>
									<Const name='Array'/>
								</Args>
							</Call>
							<Call name='=='>
								<Call name='length'>
									<Self/>
									<Arguments/>
								</Call>
								<Args>
									<Num value='1'/>
								</Args>
							</Call>
						</And>
						<If>
							<Call name='is'>
								<Variable name='x'/>
								<Args>
									<Call name='[]'>
										<Args>
											<Num value='0'/>
										</Args>
									</Call>
								</Args>
							</Call>
							<Return>
								<True/>
							</Return>
						</If>
					</If>
					<If>
						<And>
							<Call name='is_a?'>
								<Variable name='x'/>
								<Args>
									<Const name='Array'/>
								</Args>
							</Call>
							<Call name='=='>
								<Call name='length'>
									<Variable name='x'/>
									<Arguments/>
								</Call>
								<Args>
									<Num value='1'/>
								</Args>
							</Call>
						</And>
						<If>
							<Call name='is'>
								<Self/>
								<Args>
									<Call name='[]'>
										<Variable name='x'/>
										<Args>
											<Num value='0'/>
										</Args>
									</Call>
								</Args>
							</Call>
							<Return>
								<True/>
							</Return>
						</If>
					</If>
					<Return>
						<False/>
					</Return>
				</Block>
			</Method>
		</Block>
	</Class>
</Block>
